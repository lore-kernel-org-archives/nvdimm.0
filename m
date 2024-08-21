Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6913B29B
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724266850; cv=fail; b=BS/HN0O//APaOKo0YLz4Twp6uHXN32JoLbRp+ToLwPzieu6vlSgVTjpDE38CrptH6NBzYYWytwVyNLKz5XkhHB0R8D1Wo+wYcBEP9VBEJZlANEMAsb5+rwB42NwWEBemfV/d9C0/ljodtK5UT0In8mecIM3h/KfPRlqpq0lI4PY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724266850; c=relaxed/simple;
	bh=ZgYA/Gh9CcvLB/jW7XT+nFLISjP6LDUzc55N9mkCFIU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MSRUWdj7TJ8kYQ93PoRzs2wFXejo6iGV+V89sutvQZ29rw1Sk+37t2l2svhEQujtqvX7KPu1XPFIk/K9DvqynkyJl/dh/91BaUozBqNXpxlXiI3wXMKs0hIdkY7jTsFvSQeLoCNTRiYCWdvaTMGHa1JLhFjb8cUmSqJ7SdOi2HY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JckPRDNq; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JckPRDNq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724266849; x=1755802849;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZgYA/Gh9CcvLB/jW7XT+nFLISjP6LDUzc55N9mkCFIU=;
  b=JckPRDNqAMAClV5ZPzsDfDVfa/IkzGkyHuTIJJ/Ko4sPpEMW55BylxmU
   SV8DBfC7m9Ij9Wcyw75LVmUMX5PTjLAu3/d/BRpryWTwoq5zi6aHeB9kU
   sUB1zGFK9LI5a9PHUz7NYyEIfK4mF3+tO506brPlYhGtkVomJDwpSsBnd
   r0q63MOeB/nuoModsTWCXCmU3UoY+d0SaMNz3tilQBiDR3gBtCWgwuGwj
   Siuf9Bswqwt8K2PJBao0yIPYaMzcye8OZu0rjO7bcUhFOGKX0N41DFSnv
   sRK32/H9vw+sd37M2puD1ma7J78AGuiyOB0cXUWRGww34ZE8bKLEAGMkF
   Q==;
X-CSE-ConnectionGUID: ++2c72QfSemNUnYyDvsAMA==
X-CSE-MsgGUID: x3MMlt7pQZS0Mj/AhGbatg==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="40109128"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="40109128"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 12:00:48 -0700
X-CSE-ConnectionGUID: EITILN8aRwukS5B93aFAuw==
X-CSE-MsgGUID: 1QveioqlTYq+Edd+kC3NFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="66136455"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 12:00:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 12:00:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 12:00:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 12:00:43 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 12:00:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7O5+nsJxM5itvzeBSgELuom0hDj4MDsz5STgCLuGD3UfHpH0/Rwua7tq/ByH7qFU/YoQlViiwk3uomNyem9/zn6HPiVM2BCoZpQeNL7EJUzYDzhV/2H+3H0M+spEVKpcyDxtSxbzeyGPAwjhzm17MvGgmqnHXCsTqkx4jVr4ReCxUekYXThHt/5unT4PyaQStf3k2d8CgezO8yrm87mPKkjhsvo7h6RCbFm7fm1D0mCtxFBUjkOkcazXW4YSs588fdZB0+eJPn5/vTtGO5J/d0xtDE0ei9cGbP9M/3gOessRQI2xvVNPf9AmYt+edcVsSOHddv0mKN/rSi0Lw4ObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AY16Fhf0Lx2chclKXdJCTYbZfoxOlAYUEwzPNZLxmHg=;
 b=dlNTkjP+AQMySMO5SIOwBa+Udg9RrjJOgIchKA6EGitLMw/dGPA2++xxRHupme5GnHrRhtfEkGPXDRNZ2vKhHQzzV/WaQ8ATF1PyFT+n663/AceV2uVmFe0akQxXk9GF+9YjPKCHQ7smn0M4+Xg4Iam47B9iCzQLwELc2Y8BI//BKc4vdM+2Y9+bVoDDZKhHUnyI4hG50bD6qNPdF1H92W74JwmjVmhXFe/Xr5qPlNmJ9zLDhUlakHk/jpryGO8y8mJIzaYyTUeWElmMRu5RgPu6SzWZysuCCckF67hnlHkJfsDsRGs4nwZwzdPKkMNqi07cMARqOiITWa2mSL2+Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Wed, 21 Aug
 2024 19:00:40 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 19:00:40 +0000
Date: Wed, 21 Aug 2024 14:00:34 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v3 1/2] nvdimm: Fix devs leaks in scan_labels()
Message-ID: <66c6395260897_1719d294ec@iweiny-mobl.notmuch>
References: <20240819062045.1481298-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240819062045.1481298-1-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW4PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:303:83::30) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: 43ba3cd6-5c43-405b-b8e5-08dcc2138c88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BVpY+DM/xDGedIPxfoqetBDZcIKwPTXh6waznupuSr0VbILLKCMUs6hCIxXo?=
 =?us-ascii?Q?JMWWhcaTNgoQc+RnA5AKyN0FmJ+r+NyfPYXP4l8mrEZj9XLn+FG9pLv/5/T5?=
 =?us-ascii?Q?BxjaHPsXO6zl/9tr0OdqBROzBA0vh5Yd3xN/YnayeqISiYauqIorjzXHUJ7Z?=
 =?us-ascii?Q?fUUCLeOwdXT95JpNovE1onFI6FvA0D69Lkixzzr1HKBXcCBrDLYXLlrKYtLN?=
 =?us-ascii?Q?ShtYPP1ZlTR65npoGTG36CPcGswdUZX/bs1UnFXfUoVP2XG092lL7ZeRY1xm?=
 =?us-ascii?Q?WUbl8fwZgygGx55XKLl8tMX+P88zpp4RTzG4X0HECDb44Y5p0ww1A7dZbRxa?=
 =?us-ascii?Q?yqoZ95IFIHMCzObnGSQ1x5EqTXjpBVdA6UPujs0VJf2Dyphrn3G7pY978m8k?=
 =?us-ascii?Q?sDIQJ5iWN3NOQEgf0LW4bXZajArSEySoiZF1QPDcPnQapSi7sXPmo6/pPfEk?=
 =?us-ascii?Q?3BZh7IAbzRchFy/25z6mWKc6fEzV3BUKj/gf19WZuGYhmrcXg77dMoRSfs3s?=
 =?us-ascii?Q?1eFXSXY/ZVo870AdvAkOHgpkDPxYbyjlXjZa87tL1oLaMNEqHK6ZGO4cKWkt?=
 =?us-ascii?Q?PLCh/zvu/2RLnZ5kgjQZ5OArsZytWYGrCSG+Zu46gE2rXRkd+tkghpH6uI9X?=
 =?us-ascii?Q?sNK5gpDrjykbOsU5S+PD/LyVL7bw2mSoPxjo1QczVlVZ5sKoKSJBKcmSZOMg?=
 =?us-ascii?Q?kelWrnpAD5wzlf9UoRzNVXy+oKwoZNe7sbRO6Zvp3aHls4PGC9sqZBJagTrI?=
 =?us-ascii?Q?ee/0tFzmWKl4Nu51O4oweNXitXaABmERylYQSJWImIfbpzBn/v0VphpxkB9O?=
 =?us-ascii?Q?xezzxFZGPEfaI6Em/fal3ExcXUdHaU7ykSBX469o6M1eLANMPqShOFjbdip2?=
 =?us-ascii?Q?WlSdeyq3O7MGvrHc32biIBs1dfU9nsOBO8MXO9vC3d1dx9QY0TsBuujtbQxh?=
 =?us-ascii?Q?g1hTbybX7p49msqkKEkh2GfDy9WuEFQcVtpNaSNvrbgZlopSwDNqZOp+60oz?=
 =?us-ascii?Q?cYGT+qbMyqAJeEzpzbRxgshvVvoR0WdRFd3SIo1B3gX7j1kphM7hOop9skh9?=
 =?us-ascii?Q?19ZpDmM5khxqXKNEpgGg4ypAJOOzjstHD5QNMZir+ZCIymhbfmoYk2LB5GUv?=
 =?us-ascii?Q?s07caB8z4/khBqAIAyJTwg/AWGzorL5nfPXJo0XiyVmZb0QqxaONyj25UYaj?=
 =?us-ascii?Q?e9kTiZb+zGORABWCGOWmRflYXazlthIkgO0/f7M6DJIv/E8nXDKk4MyKKrvi?=
 =?us-ascii?Q?GLHpdAVT7mLbOy+wdPXpoqJQlpFSKdVU5VTOgZP2A+/5uSqD9Ahb40KTyBzf?=
 =?us-ascii?Q?sgUGBhxq7GphsBL0uGu8lCYW/QRKeNZdGWeOSsAOYe6GNw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qFXGeu3KyWBXZ+SPnpKyrOsanCm13Qolj9C3HQ88PA0avqEI77q7HDBkWDDY?=
 =?us-ascii?Q?z32SV+SPPWpgGJbNznbMuoMeXMopynfrRFqXMaAlEdHelPuZylsW0Xp7shLF?=
 =?us-ascii?Q?ZDoZggJyrDmR11la8NDm8MZRZ5vu8jtkWC1cdDOHe9XFfh9tCWT3AvMFyHEW?=
 =?us-ascii?Q?T3h1ZfQ6ZS8XSk4LwketbR144mR84KcYhvLLkAiDvoHmRTz6T+EAtL6T+GpK?=
 =?us-ascii?Q?4FZKCh6egztgzUJHnwdKkHkEFG5R24KeyweQuE9FwaBUx/EMn30VT6PH83j/?=
 =?us-ascii?Q?fcKMhsmMIy5vNn/oCUJnUIo/TaUBPgGxPcZWGZ+eAwPTZ03/R0fmOQTzT921?=
 =?us-ascii?Q?8JUw6YkjZW9cCKIiDTR7gul9a/aaFaYsApdWnoYB68EZ/OVKcAuHeArPVFGE?=
 =?us-ascii?Q?t+1kxTgMKKBXLNJ9BQVhOvSDT8KjxpnUh4UHCgtJ+C4ZYupymnSjNqiEYGT7?=
 =?us-ascii?Q?/oSXIIeMyTpn1Gw/qVYLkKeQJ1T8DCuSMdHNtc00bwQljAi/26g7OwDtBm8y?=
 =?us-ascii?Q?qK8pmezrCE9H8V58AL1o22HHI0syn/8FsXOfc9ojDx6UR8ahreRfoY//J+u6?=
 =?us-ascii?Q?X9XEOoMNV+1Un9nOfbwBQ4n67gSffd/P7fl6pel/2WljRU02ImeM4DJYSMPW?=
 =?us-ascii?Q?3uFIpOwogHnErJx9D0sbUDfpdDKnNlj5JpUFyOTr3uBYyEjOuRuM4un7gLMg?=
 =?us-ascii?Q?IokAINGE+dg20Zncz3Ojx15JgRElcI9LDq80MnsEJgCZT6rdh3BQTWo4/OtW?=
 =?us-ascii?Q?08fkMQ0Ynpmr+JkqJqwOX1/ksphOVefuAMMuZQJB9+eS9mySdXLEYt3Wn9Ya?=
 =?us-ascii?Q?1oHSrp8NQHAr7hj+YFPh6mtBgjYRNBup+P5tOYKBmyIbBep56Ez8EVxWowU6?=
 =?us-ascii?Q?3pcEm2kjkCpnahhZBTNxvE8DmM3jOKwc4KW+I4D4UXeWDPzS6dSEpHVg+Nrw?=
 =?us-ascii?Q?7N+3tp4g2aZl4nIzydzW3XI66GON2E9xoO9By5d2o3wsoRBrIyHfuXIrfoZT?=
 =?us-ascii?Q?EdGCvnkW4HDJrfA3xz7dtzyyZwP4oV534cV1hfG/YwBctYgjak8QG38m/aww?=
 =?us-ascii?Q?x+9llPGK+ZymKzagRD+3X/N2wbOYhA1Qg03/+ClGgtX/S9R66Cxj+WwT/BF4?=
 =?us-ascii?Q?0PBL4wvPuVWoKe+hPxhPWyNSpHYxatacxMNvWktEtjzGc5KeE0Z7sN/UYT/i?=
 =?us-ascii?Q?6TevRe234F3W+Pz9YmoQ3wDLrWHvL6kzrjeRzEoC30vts6243QkAPnQSs6eB?=
 =?us-ascii?Q?J63jaUGzI+fMlsYy6XEZ1mAmO71lMSOeVO7Aq3Ir6n2qChNGYuu2vCSgN2/A?=
 =?us-ascii?Q?Aaf2i838QY7qhPv+NxY3NrbMrqFNgx3MxY8QmtbVKhlpretu/B8/VXacFAY2?=
 =?us-ascii?Q?dGHAp4XHKCqQm2IY40af4MNvbYmxor7zdX6uHWGH0kSwTjiGogpvE4sUYwPb?=
 =?us-ascii?Q?WrMoIDdc2wWzwJvUTJjg9S1yO0hDggfgtmoylRVoYLqQ2XET3eRmhZ21l0LA?=
 =?us-ascii?Q?DGc/v41Hfo1RBqr9+7JV6tET0WyOeIPbfDIfR4HtUgB2TYsAmetIrZxLQeIe?=
 =?us-ascii?Q?c5K0dHIEP+zW8NcHyiKBVjkfEM1EI8lcojO1Bd1B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ba3cd6-5c43-405b-b8e5-08dcc2138c88
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 19:00:40.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9uKFbcMtNSxqOZCgMD91++ffmxwABkc/XKhpTo5o8QZY1oCGXXzHXyTsFQpHy7Cpi7YS23oCYUpdoZn6ki03g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> scan_labels() leaks memory when label scanning fails and it falls back
> to just creating a default "seed" namespace for userspace to configure.
> Root can force the kernel to leak memory.
> 
> Allocate the minimum resources unconditionally and release them when
> unneeded to avoid the memory leak.
> 
> A kmemleak reports:
> unreferenced object 0xffff88800dda1980 (size 16):
>   comm "kworker/u10:5", pid 69, jiffies 4294671781
>   hex dump (first 16 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 0):
>     [<00000000c5dea560>] __kmalloc+0x32c/0x470
>     [<000000009ed43c83>] nd_region_register_namespaces+0x6fb/0x1120 [libnvdimm]
>     [<000000000e07a65c>] nd_region_probe+0xfe/0x210 [libnvdimm]
>     [<000000007b79ce5f>] nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
>     [<00000000a5f3da2e>] really_probe+0xc6/0x390
>     [<00000000129e2a69>] __driver_probe_device+0x78/0x150
>     [<000000002dfed28b>] driver_probe_device+0x1e/0x90
>     [<00000000e7048de2>] __device_attach_driver+0x85/0x110
>     [<0000000032dca295>] bus_for_each_drv+0x85/0xe0
>     [<00000000391c5a7d>] __device_attach+0xbe/0x1e0
>     [<0000000026dabec0>] bus_probe_device+0x94/0xb0
>     [<00000000c590d936>] device_add+0x656/0x870
>     [<000000003d69bfaa>] nd_async_device_register+0xe/0x50 [libnvdimm]
>     [<000000003f4c52a4>] async_run_entry_fn+0x2e/0x110
>     [<00000000e201f4b0>] process_one_work+0x1ee/0x600
>     [<000000006d90d5a9>] worker_thread+0x183/0x350
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Fixes: 1b40e09a1232 ("libnvdimm: blk labels and namespace instantiation")
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>


> ---
> V3:
>   update commit log and allocate the minimum(2 *dev) unconditionally. # Dan
> 
> V2:
>   update description and comment
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 34 ++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index d6d558f94d6b..35d9f3cc2efa 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1937,12 +1937,16 @@ static int cmp_dpa(const void *a, const void *b)
>  static struct device **scan_labels(struct nd_region *nd_region)
>  {
>  	int i, count = 0;
> -	struct device *dev, **devs = NULL;
> +	struct device *dev, **devs;
>  	struct nd_label_ent *label_ent, *e;
>  	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
>  
> +	devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
> +	if (!devs)
> +		return NULL;
> +
>  	/* "safe" because create_namespace_pmem() might list_move() label_ent */
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>  		struct nd_namespace_label *nd_label = label_ent->label;
> @@ -1961,12 +1965,14 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  			goto err;
>  		if (i < count)
>  			continue;
> -		__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
> -		if (!__devs)
> -			goto err;
> -		memcpy(__devs, devs, sizeof(dev) * count);
> -		kfree(devs);
> -		devs = __devs;
> +		if (count) {
> +			__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
> +			if (!__devs)
> +				goto err;
> +			memcpy(__devs, devs, sizeof(dev) * count);
> +			kfree(devs);
> +			devs = __devs;
> +		}
>  
>  		dev = create_namespace_pmem(nd_region, nd_mapping, nd_label);
>  		if (IS_ERR(dev)) {
> @@ -1993,11 +1999,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  		/* Publish a zero-sized namespace for userspace to configure. */
>  		nd_mapping_free_labels(nd_mapping);
> -
> -		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
> -		if (!devs)
> -			goto err;
> -
>  		nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
>  		if (!nspm)
>  			goto err;
> @@ -2036,11 +2037,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  	return devs;
>  
>   err:
> -	if (devs) {
> -		for (i = 0; devs[i]; i++)
> -			namespace_pmem_release(devs[i]);
> -		kfree(devs);
> -	}
> +	for (i = 0; devs[i]; i++)
> +		namespace_pmem_release(devs[i]);
> +	kfree(devs);
> +
>  	return NULL;
>  }
>  
> -- 
> 2.29.2
> 


