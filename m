Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637BB27C167
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 16:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751386602; cv=fail; b=RQaLPWCK02/tVm5Iw2cIf6g+vRv4Cvgr/JWNW2QYRChUDKylnt9MeH/Wpf0kELtGY4lrPXz/JEe0gi2QgdhoL6ySWpJVyLmf+ugkIevgLnEWnn7YLfNd3xkWDT1YqBH5rHFJ0awwp9KZiFuMBC6mHojkuPodlVPVGC2w7Gj/joE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751386602; c=relaxed/simple;
	bh=A2DiQZnOuhejP5dgz8xGzzgZU/7whV9z4ChwVeSiojU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pm5xqnsFxYuQaeJe5MFuMRASP0T8EnXgoJJNkF7wtt+wEwBtUrPRPUHhi7Sd22GcFOiYmErEXJkdL0Wyqw5ZD046JNLR9C3X/IisOuNgVsP124EHPwwhq0A+K1ghbmCgWMmk3xI6OvmKVcpZjy3B9SuCdxx+soVqHCJO+proy60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AiaGKXFP; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AiaGKXFP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751386601; x=1782922601;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A2DiQZnOuhejP5dgz8xGzzgZU/7whV9z4ChwVeSiojU=;
  b=AiaGKXFPSWuD4JPZAe9Y8hn4hJ12Us1TjEjrRV1IE9TSgRSvu2LsRZ6V
   TQDRRHBeiTUM9ZfA6yi8Ea2ZNdgzjpCUX1p1mbq6MFCjQe7+goTmXV7zJ
   OTGdgD3rY9VPHj2/qBHexkC8OufK1SuoTXNmQuevaCggECYm4tJjiAdgC
   0jc4B1ZxZn7IQH8epgFLntsHpomVCohCtOuGH67/jzTjJNjNoXDIyoBAE
   3q4ExiViJ5/k3kLCGiwySQaaI+QD/xfxaDR2zkWv5faMtQIk7AQBYV6ru
   GSc0hsUr40U8Jdx2gEaz8og2wp/qSLU1gLBWDoYYwZHhyUIRhp8yf+MWH
   w==;
X-CSE-ConnectionGUID: uiSwC/6UT9+7bxQsTe87ZA==
X-CSE-MsgGUID: Uc0niO9pSZOuV0VVEmJ/cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="52893067"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="52893067"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:16:41 -0700
X-CSE-ConnectionGUID: X86DRDhSTs6kzliTP4ICQQ==
X-CSE-MsgGUID: iVrUCijeQGWNracoI8IMAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="159327956"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:16:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:16:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 09:16:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:16:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICju8+ZNLN1M0bkJUkjXKZ/9Nu6Cty1JfK4AhZJLRGU7kUYDRJ3hAc59NlJEUK8ErY+RCAuq+TlY4k/EhMXLDmuNTM09lRnyms4799HMb14da/365e9qQxFZL87tLG7H1hncrIuw3Rx+BLyGRGQD85wx0bXIqO/bAfi4gpdASx/E8K1Y/xQktajezb+AOiXObi51KiWrWMytpeJhq0p1j9MohKHxDjH8BaOiJecK3IX+gQAef6TnOVCF2S8kLL0KSdDfN4P8wCDXerjMCBGGOJhKWnNxpMPvddknmOXOQCCP00lgdKusrO1CD31egXOZJG1i82oku73PM54u7K83tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnavLTf3GXANfpcu0+1NNZgdxyFhlrzLgiOYOMRhLK0=;
 b=tz5h9sTGOM2LnA5Oq824kM/ptXu0yQEfLUL18jscb9x4paXdEHCeCZTiKvLDJmrIkYFndyBQZgBqSGAJitenM4PV452sdIsxop3b4V466pQoEdWHvUswnsehgG+J/DP90C5XR/J8LRYyEn3uLvk2qKvt0HV1BR0CVK4Yf/DzKzZJky/ZV7ixdox8sg8x2G0dTWOIfSk3EVD6BQ7mimYMQuc1U6ApDKqFfEQ2Fcmk7SX5Qke/nqfFAgzdQ6/IYQ9YkGRmQlDPuxESKhwtoN1oOX4tPQNzfN2GuRatNOndoiGsxakQ0ovC0ThLeUAP0sp8WMvVMGizrY6ZlkYRYHdtPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA1PR11MB6196.namprd11.prod.outlook.com
 (2603:10b6:208:3e8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.32; Tue, 1 Jul
 2025 16:16:26 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Tue, 1 Jul 2025
 16:16:26 +0000
Date: Tue, 1 Jul 2025 11:17:54 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v2 1/1] libnvdimm: Don't use "proxy" headers
Message-ID: <68640a32cf1d8_30815d29481@iweiny-mobl.notmuch>
References: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::16) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA1PR11MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f0b2701-e455-4c83-bfff-08ddb8baa10a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FfRctjPoY654jkc5HyF7kdwPExFFMqBOmtEqUyDodctPKxIglycyUFJNVu0a?=
 =?us-ascii?Q?68IfEXgmSPU6xFm8k5riGhgietXnYuUw3R6qHo1d/zu6PwSVYUhNdRBJhRsK?=
 =?us-ascii?Q?H5Y5x9Z51g4hXamhOzbYlo+WXye5jvE5bdoKrEueZNAMZYJ5X3VYCa+T0RC/?=
 =?us-ascii?Q?GPFnHE4SFTczPvFcu1CMLyCCoYHvzuh3/Qn5Icb5Sa5R78niQc6TpJZBDab9?=
 =?us-ascii?Q?W8llgRlYDl8tQ8M6da2jczPzkZwyXkSnwyOWU7J2rHW4zom9k6ldZyEA10JH?=
 =?us-ascii?Q?cRWpqnWuCW8TI7fYQH8c6WtESC9R8hlmLcmQyZQvLxJhnwEFokmKmwzDKT3A?=
 =?us-ascii?Q?wOCm0fA+XiXsLkiesYGqiZofjRA9cdUxZav9b2JSA5VkdVyVH4IEsX7dDsY7?=
 =?us-ascii?Q?MfIyudI/+R6KKpCpxFDLn9cSk5YtLHMl3TPIRU8PtG4NLbSxv03PiSsC/BMJ?=
 =?us-ascii?Q?7x51cA69/Pfh61dB92y0RUMAoUrTrAWsIcSG+QAdrqZFZxu9W4qx9ahTpERk?=
 =?us-ascii?Q?fmOvq5lrkd9UqezTueOnKk3xEEcdRLMoq4PBHQgsrYspVMBc3/g+2mPqYZzJ?=
 =?us-ascii?Q?/IKl3Iuhp5e/SxSfYnDYXlJNX395ll9eOw/51xAZgXzd2xKKzmyiUo0SK70+?=
 =?us-ascii?Q?O2u7yRFPg0bst6VJcWXe9QhiLSlJqIjxfqadid+AVcQLkH9vZNW1RdPXYjbi?=
 =?us-ascii?Q?KeHFcCZl/+cq62wKp2/K6CCif/rdZAe5S7rFUAQno2tDFC96yzDhOt6NIy4m?=
 =?us-ascii?Q?tN9raVmHjWaMtQBvY5lqQ0ZGA6FzZhSu/OH/tI475NQf5YV9X8k/JOx9FEsY?=
 =?us-ascii?Q?UATo2VyxwT8CSWQ2xtDz6s+DgTGjm71RU/9iT9h+Sy/bKXE6egidUqHTVdLH?=
 =?us-ascii?Q?depo3pSJRYP4jKGdDdnGoqfgtVfi4mvx9K3EdJWaZ4oPdW06zCNzscD+9ONH?=
 =?us-ascii?Q?PF90F+KHdsUGcdn4Z1jR9DSiTh3D0TXsrFnEUJEqV/beV3TmUjr3JaxaQCZT?=
 =?us-ascii?Q?C3B+lIJ2fKs9oFa9XMJiJOtBWq7/+A3l9oaQLDCZVQPgxBjxkNikMkHDN8OE?=
 =?us-ascii?Q?LcXSoVpoyiNKchVqSJA1p9EKnd9nrCZIs4qVksiCWZhKDTlero5mW7ygmQC8?=
 =?us-ascii?Q?OI8PV/oj8W9IFifPs6AVIEpeFPPdZa/rcwK/MNOrBVY41wctn6S0EFSRHIlh?=
 =?us-ascii?Q?tosi1Lzfyl8oA/1f62+iodhhs/xkwwMvii1IVSjcoEwrCm6j7yt9hRS9/soz?=
 =?us-ascii?Q?uHN6Llnq7Ddmi1nID0+YM9cXwp65bXByoHVHS5bQSswspGjPIyH8Y91i8xYY?=
 =?us-ascii?Q?hbOfz/IWyHjfPIX5F0nI/lO5IMpl8cAG8cEG6nWu2+13Dg3kNRj7teAG0QLS?=
 =?us-ascii?Q?fIInumQsKZRKF+lFtcdwu4B/kWTcFcIzTbwSkazLlENkjO2IA44ozzuO99gd?=
 =?us-ascii?Q?1LwQ7VtrWE4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rZWlVfm9p/Pk20ERZ4wVHafhAZ1chpYw8f1i/8xNkXXbxNBgjDETBbazGvy3?=
 =?us-ascii?Q?Nx6XYEKeVTIuUwkQUzUL9H3QV0NSCWGWy7czVt4dPI3ajq3INH/vSevT9M0e?=
 =?us-ascii?Q?+RRZXYGcjlGEM4HP93CBymJBg9uE++T4VqBFlp8dNbUFffjKmPeFF5qt9Dlb?=
 =?us-ascii?Q?Zi9jfy4NbbNAB4MGLOiwIPzQBib5MBUEamWCH7uMN506RcTuq7/SDKwF++KX?=
 =?us-ascii?Q?SAtqSU45dLNkE0L++By3bOdEqayFqrftHrsip/2FgOfOuycSGHbM37uvRCvW?=
 =?us-ascii?Q?buWraIx2bkN9Mjt25AMUwJ+e0ymW7Q+kwF1uKNVL3LJgwaU/AqFzRVgrSPsF?=
 =?us-ascii?Q?ogy5ZPVVPQs7KXcrZulHQC9oQV1TaDdOufABSWfkl1eXr7tcRMfs3V4QGI07?=
 =?us-ascii?Q?+r2G04U83wVfJuz/Zriv+GWpmyrX7FyuUgf6tRa3ejYA9sdxbJlLhDEb5meE?=
 =?us-ascii?Q?0GI6sY2jndXQRB6ZErmjYIhTb6TBCeUxlVS1gFtHfAAPZNvO9Ha22i9tFjdU?=
 =?us-ascii?Q?Va5XkOPDhrq5jzCXF17u5cYNAbdLcvOgLoJOKhil6EtRNKVKE548uJXfYylf?=
 =?us-ascii?Q?4NA6YvCSiE/1t3Jxb01IB7I+T326nLoIGr32F78NjZkO5rIN0RoW2a+2WwE4?=
 =?us-ascii?Q?wlI0FPyUaLlA4cjtFtcIpBOzyvejZriNPKHVlXnzW//v6irENlEY91zfJJPq?=
 =?us-ascii?Q?Xfo85okg962BKoQn1k2kek8x3ykLWcz6ArhLFSfUgECV+OfbBS4A6Rg9R36S?=
 =?us-ascii?Q?DffBkYCEfH1kaDpE5sd+ms22RNVT9P/cioGHgA97zeQH0cdaiZ4MU0Up4n6k?=
 =?us-ascii?Q?H1/EXMEV9yNu//aHlt6V183jlc2CQWKTnLniVjMGZVQWkw9hGvntOkta3ESu?=
 =?us-ascii?Q?WZJFrJxY6opovjQ6d/OggPN6Gtd0wpBntqPyNG//EFoASHZph2WG1+SHyMlk?=
 =?us-ascii?Q?IN/G1qAtOthpYTlfVGhw9GMhUiFk/8FOoQ3yx4SyBawijs/n2fOBiy1nRsFc?=
 =?us-ascii?Q?ts8GV/bnT+i01i5boo1v4lKb/whcwrOOdLPDEEqC6ijssgLsBnpgfWpAwZTA?=
 =?us-ascii?Q?KMl0Ir3gqK/4d9c0ekbwIZ58ZXGdrgdSsVyPOFv/DO2+tWKUdbkDzcTivosp?=
 =?us-ascii?Q?PX6P0iqOArshOiMa/2COg9pSFC9HXcvE/opTZanOBxCSuPWAr4NlGRJ+v0gn?=
 =?us-ascii?Q?Adq+vbvEVJCJz2+Nj1JIAJKLrLIkkahBIVxc+PrttSN12AGD1HfwiUoXp5lX?=
 =?us-ascii?Q?w/Cvs3wWGIrkVxG90zBxPL109VgVPkGbMIG83gB8l0B158dyzcA7NhPa35ZI?=
 =?us-ascii?Q?oyQW03McKRFsIwsOYEq0BP81MbQPa8NbReJE8/9k07481gO7D27hp+l0KBll?=
 =?us-ascii?Q?+SEdrK6PQPOHEA+XPxicE2Go0CZtI28gKeWfRN3O+oM6PihV8blk1Zou93Jd?=
 =?us-ascii?Q?jqhu56K7Og1KeBH16fLtRMJsShM9x3Cf0d118IdV95vLq7ac+PnlbaB+E56E?=
 =?us-ascii?Q?CJHZbpSCeDAbHoiSf3bJR+RwkNOCQaAakNfzgmie3b0+lCIbnz6u45QbHgWo?=
 =?us-ascii?Q?xhHtv8ev+DaiNU80jPa4ZrlMXG9cFHikeu0Eggpc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0b2701-e455-4c83-bfff-08ddb8baa10a
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 16:16:26.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+awyG0KykhSIeXwSbaJsH1sukT2L9tn9slbVgVaX109XPpkjo0vJ0PpzWn+cSLO3HNbzFyPeN/cWPjcoTG+sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6196
X-OriginatorOrg: intel.com


On Fri, 27 Jun 2025 17:19:23 +0300, Andy Shevchenko wrote:
> Update header inclusions to follow IWYU (Include What You Use)
> principle.
> 
> Note that kernel.h is discouraged to be included as it's written
> at the top of that file.
> 
> While doing that, sort headers alphabetically.
> 
> [...]

Applied, thanks!

[1/1] libnvdimm: Don't use "proxy" headers
      commit: 536f5941adde41c99a18a0ba03b457adc9702ab8

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>
