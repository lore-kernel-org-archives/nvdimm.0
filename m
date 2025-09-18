Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196B525B301
	for <nvdimm@lists.linux.dev>; Thu, 18 Sep 2025 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758215913; cv=fail; b=ktTRxAQOyjhiOmUoTaTpFMiQMdrXjeoCvZpgv25bxw6qQNTq2vaxl7aTahmbmz2qGfmPZQ/g943U1eAbGsV2EiNOVtVqq5wiNNLh39MnK/iDFhcX03TzJLZpmnDkyT6GxY6LaM3Mt9n4tY++CwRePkuqevB7ArahYmFIQQLMOWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758215913; c=relaxed/simple;
	bh=r71SKjG7Vg+HiWZXC20SsEVV5Y59jy8jIG0GzqplTZ0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a7XUnWdDBLRD3W8MGxyXGHSfFu+/rxI5XV8TJ9DeVmOrOUB5hbIJxN3iRqdJk0TNsDQ6iCJxHhvBnwUv5LPnpbH59EF74t/qipmVw143SF0DA3v1GjMqaf/G487+9knTlZ9Gh3VIpercKVyz0avc5M9hTdNVBvbTTmYefd48lRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EowQP2eN; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EowQP2eN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758215911; x=1789751911;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=r71SKjG7Vg+HiWZXC20SsEVV5Y59jy8jIG0GzqplTZ0=;
  b=EowQP2eNwoLdnC2YDoANMlR1q+8AcNLZumb4YDgyHpPgfg1ljQOI0MZx
   YWsgDm+On0thaDqUIQ9Ggd0cQo9/dM+Sr7SZsTnYO6l9TePh21crZZtSH
   1yMYambaEAjELqMi9idZ3ZCF1nWufuvNP96jyyi7Y/sa4IRH82X0FueX+
   fde/MrO57DNccHS/5XpNM8zNJYbe21/vkCpTGf7SuP9JB2PKQG7Kafbwh
   pAqHurrZZ35ANYF910LKO++I7K7R0YmmlJ/TcobPOUJ6CUylNj93jyjiL
   jHJ5smCBBsLf6/1T8wHKV8xCsZVIGyljFvg/sJekyBBOWMBf9MQ3TbJe6
   w==;
X-CSE-ConnectionGUID: eUFsemDGSoyolntaBQqO/g==
X-CSE-MsgGUID: 3NGBYahMS1Cj9ojBjKVyCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="64194407"
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="64194407"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 10:18:31 -0700
X-CSE-ConnectionGUID: up1bR9uNT/id4XtIEqUyAw==
X-CSE-MsgGUID: jsMwcLk2THS6KUxt1e3XIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="179885694"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 10:18:30 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 10:18:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 10:18:29 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.48) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 10:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LzJ1/StRFNYjQ/xP+rq8SGuAqz41/R6q2x/kc5QO9ilb7j3FoognqHffOTxoD/QmtQ0ilkw4Mw9+aPrSoonIPWK9oy51X9HfGNeDiwFVwkpgk+n1dKPRuzk4kAgLFKQQjEhccWb70sgMB/u0IR/f7aQXv2UU9XZVhfu5/y3Kvl23OWlsf4qJ4GL0N7dYx6GYQew+giNsDa5XVu3dVi5Red09aEtklyfvX3AoaajgBNZvXQmc6cIfsp9eY2ODxMPljTUao5+Sc8CZinpgTMgwmr9ChR3pBXc1E80kcrO2w+yXnQ0iTeySaXLT+3TbmzksrM4M3AakVc0znZw0g2+Osg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lITiLWgnMXD3z5cuINFUFn4S7xpglp1Gb+5H6C+wj9k=;
 b=HgkrJYzckTnDtavwC7qy0P8/xSqDgqlyo2+V1dCN4E34pi8I5ht8XCklRsc+L/Dih6a5zUzSINeerlOTR01pEaSmclQ0BYhS5ez/j6z9SlKBhuKly7NUwo+jjfuk3qYtcGGWieyqysvtIU9QL2wrpimX7v7wurCc99ZZqbbR+JcDVcO6+Nxq1vnZJGkTZVZ5Adq0epA6pqMvkwEOzYwtfRmTHawPrJcg452A8vHjaVfGnh4WfNj/rXS2ucC3Zza99/XtDfhIkN8ZtUX+HB+QLngzdQX1n3VkApLDm6vdYX6jcqwsxL+4VGQg4mntwhZ71m93Qq6aM+6L7i0BYcFC1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LV3PR11MB8529.namprd11.prod.outlook.com (2603:10b6:408:1b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 17:18:27 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695%7]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 17:18:27 +0000
Date: Thu, 18 Sep 2025 10:18:23 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Santosh Sivaraj <santosh@fossix.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] nvdimm: ndtest: Add check for devm_kcalloc() allocations
 in ndtest_probe()
Message-ID: <aMw-320nl1PJBlCm@aschofie-mobl2.lan>
References: <20250918141606.3589435-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250918141606.3589435-1-lgs201920130244@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0362.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::7) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LV3PR11MB8529:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb5bdb0-8138-4097-94c4-08ddf6d761aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uHrjI8ITZkp8P/kKSZBm/zCTNB206Zkm1lYP5iB04xSG9jv2Z1LHr5x5yyXL?=
 =?us-ascii?Q?EM93tvQ3dH5XvxvxHOCdvpL38uiIPwzVukD+nInM5pRUr4Zo0RqRlCiEANr7?=
 =?us-ascii?Q?wnDrsyqz/OYmQRtc9U3O5q3Gt48DKjcArfXqJxBpyg4USF/JFv6DlkybPw29?=
 =?us-ascii?Q?EqvYKnMI8QMav6gvjNqR8wkP2fe2uzd+Q6LU2BHUQEAC/nzcoyBtMMatUG5s?=
 =?us-ascii?Q?TA16npvSTUQKX3VUidBfeivukvAjp4yg+YoD4MYVKSJyS6VMssFFDarIhrcf?=
 =?us-ascii?Q?1jHnlt5ywkzQOia7rOvInX5h+8FPnH5F7XngTQZXyHK4J1HQPm+e++fb1dKV?=
 =?us-ascii?Q?O3vl/XmrggVpH5vavmCQH4PoASclfCrfkWWgeH4iFobBH7HwkP6sQFJ8tLrw?=
 =?us-ascii?Q?rWEhfbDAVxh2un428JtrD3sju6GWchxPlTHIuJmqTM/e2G1GY8xrd1JLWHnC?=
 =?us-ascii?Q?UFpxvh3PoMpkc5C5ETHJB8FXuJiZcwY4eeWNzulW45Xh4hjqhods+mxtWR1N?=
 =?us-ascii?Q?7L4LfBN9IlPN9CF8aFDSnP8XMX79iDh/pikrtlUe+xdsHROPJ4AEeagShyIW?=
 =?us-ascii?Q?wmIU7xEOA42lng4bYrDwv5KIqw/jIT4nMYAG+uMXuaEUR46C4Yvg5Ogx153/?=
 =?us-ascii?Q?TUOcsufIuUYPBeA1lCgaMRCPmlSHlQhNeu2Psg0MZmYKTVgIzmVF5Ea7kiFa?=
 =?us-ascii?Q?C/FpfbiUGH8Ap0k6FiKE2VHCtAovI2AFYL5uNWN6lbKVtC3xENVZr5c6edOa?=
 =?us-ascii?Q?4oFNnb3BSH0HaAqQ9Yjs09bTHeAjAsAB+Dr3zgrk/4eDNaD4r+UjoMdAMOow?=
 =?us-ascii?Q?vz0CE8+cxZD6O9SAfD50tOfKUklGzrPNEyJtquqrwMhsZ4scREOBjLR1eroi?=
 =?us-ascii?Q?coFLXbNjmHmyDxXDFyak6Cde1p1tIJCL4aXP0IVI9Bd+42Dn4y3YBGGLOsWN?=
 =?us-ascii?Q?2wiB8mp55/5ME98AHTTWZkZr/6PKqscqXq9NeBmjwEOiHERGu97Zlwt9iRlB?=
 =?us-ascii?Q?5pLPqSdeAwJaZbVju6HeDNac5t6ywqWJhbX8OuEny6OXn68KQXbycAIo3s0A?=
 =?us-ascii?Q?U/56YKGcwZ6ZJ5UjCtndoCesmlFPRxesQbzuM6MvfoqgvKGAC8EylewNzwQA?=
 =?us-ascii?Q?4YLoAPEqqLz6YfGhpIkRKGkv5J6DGnxJ2FQguCaMIfibBg6Q/sDsW7ApgX00?=
 =?us-ascii?Q?Y20RkW6+nlhtswVcRqNrTb3gnFhj2fUFdL3lv3sa7mwdja6S+xNAOL5P+8kM?=
 =?us-ascii?Q?XRX3kjfdPcDZtgAPS9gya/U8iQjOECzOiI49NeYCYpe5MWe0SsMwwAyL4Wnp?=
 =?us-ascii?Q?Wt4ChSskWISoeXlxYtCryjqOSO29lc+TKoxoAjllH1Tefa1acMczWYxP+LYk?=
 =?us-ascii?Q?CBsS+ExVYb2pHf1CNtugoQKFZYArkK0f/KYiNa/dh62uZb9f4iveD9Kwld7r?=
 =?us-ascii?Q?DJnISDngqEI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FTTaydx6ydPEQQZ12Kqjgru76M0+RgJasP4mpVSFgbWtz9bP71DU51Ohdzot?=
 =?us-ascii?Q?u5KUDw9bDzG1RUY3CjsImxKms79hXzvhYH2zXErK+OkVFZ+HCr3vvHl8GHHP?=
 =?us-ascii?Q?MZzgf86DhP1n12lffIaBNWoOr97MbSL832i8nZQTv6v2OvMG/o7tDcInjUBE?=
 =?us-ascii?Q?nZoAHZP2vx/QSb1lltVtTJ9W7iXGmln9HD01VnYwOcfNuXwiXNLKzeHRhKsq?=
 =?us-ascii?Q?e5xCHDBtJWq27FKZQGQIPZt7uAhRkB1ldceO0+lBYTMN2sTVF56jdDMV20Ba?=
 =?us-ascii?Q?YcGGQjE2iGkn1lIZJ+vatFpTWLm935zgaw+PBSyMnzuNKarhbl3QvaI0/vpp?=
 =?us-ascii?Q?6y/bnR6EjdZh+J88K8R27TAe/BZMgcNBMjiK/o0OalBTz8Qd5WH2uE/wflE0?=
 =?us-ascii?Q?/669uBTl/KPpDPh+RyJcE/a8t8mfhI0+fTFqLlz+8Z3dgBB7Cu+dCkslyPQz?=
 =?us-ascii?Q?223Io1FcsvZhbdP0ohl0lgCC616zNbh7y/kS9USu1vYzEfqelL1hj6RsJxT3?=
 =?us-ascii?Q?TmFxddQuhiQ7Z2N4whJXGorOEfTkfDjo3uH1PC/x1S6FFeg/hb2ApsFwl8xE?=
 =?us-ascii?Q?R89o+BAPK8d+mQAflg8u+GLBVjW68aPoOZ0I5ATh+vj6ctzxjXqM3Skmy0j4?=
 =?us-ascii?Q?nbCqdIAc3WHsdY7Vjl5TOIymF+0DFlu+el8S77ewxPvIQeuKGSLumdYJrLhL?=
 =?us-ascii?Q?WjPm7NSkNuKmFFtKQdZ3uKSui9GJk8RuIF8PVVHR8617zUTQAyNB8ISlQWN9?=
 =?us-ascii?Q?0/eGmfn0ClDTcrBmftJJT0siy/av2CpCMZoTkArak8SGhE++ePKRXkHWOT8p?=
 =?us-ascii?Q?62a3mR4nEn4RBYRrsRUoqcciSKAZR/pPp246h9ggPAz3vM9N9GdDDqvThUeD?=
 =?us-ascii?Q?iyhrzS5UnWIyftpGgzWVptJzYXUCzYGTCE64WGDo7sO+YFCDYa2vGJNsFSPV?=
 =?us-ascii?Q?FwO/2DX6t+33ePmTt5hpZC9X0hyWZqFI2GijNWEHCuKJsYnTfs60SnAMmc2P?=
 =?us-ascii?Q?U6ou07R9ZcJi6cMbWpsCdnJqbHgTl+i6fevEH3K90PaQ/CZeCngSkLYaX+hy?=
 =?us-ascii?Q?NcWi5aDsgT2nE6R4EuzBG9c1r8JTuTXzgpe1VEsxKPUgx3sni6ux3pdhZhAY?=
 =?us-ascii?Q?wEjYn+HKYW5jF/PkfhKYMPpxX5dRgLeKfsEEYgmwOeHXa4twZgA1PsEMmTNM?=
 =?us-ascii?Q?AQtEgTC/0aA7QtQ3DADKg41cm5XKg09cCtM4hEOdoux5liu7uMIl41o8+9QT?=
 =?us-ascii?Q?ThZ5QjH0mDMGuOgB7/xBMGPtjGp62oq7MGgdwqyUvhpmj2W0X53OQKU8Vtzl?=
 =?us-ascii?Q?4hqugu7zdhcZGAikHN/pDvENu30XZwsWw4Nop44kiW2vCAzQsoyHKe9IbgmO?=
 =?us-ascii?Q?Lfh9YITMD1E7xmwzaUpI6/U6n6bH35yxPXb36MjBrvcx18PrBIwzdE5pEflz?=
 =?us-ascii?Q?vVhuaeE0hs1v81O6i/E8mn2lWFqiGNqgVmDHmuoJT7mbqy5a4PCRPinoIraP?=
 =?us-ascii?Q?YeT9pe24SpEJ+3moEe/aPvEdIiiAPjjMUqGGkC4lO36+8lXhlqr/Bxnx6R1c?=
 =?us-ascii?Q?0ALi4fgatIxGcP9VzZ0lETcwmr5gCuvaSMajjv36I9UstRBwGO1j6i2/29hK?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb5bdb0-8138-4097-94c4-08ddf6d761aa
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 17:18:27.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKV8EXPQtxleLnxaXgK06YuKoUI1VZW0Pl8iR5D5UfjoBm4YklhXKFy6NMUUWeukgwzG0FD8xoLciRIZGeUGivgmXAmk6lD9b9EkJ0cY4Kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8529
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 10:16:06PM +0800, Guangshuo Li wrote:
> devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
> arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
> them in ndtest_nvdimm_init(), which can lead to a NULL pointer
> dereference on allocation failure.
> 
> Add NULL checks for all three allocations and return -ENOMEM if any
> allocation fails.
> 
> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 68a064ce598c..516f304bb0b9 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -855,6 +855,11 @@ static int ndtest_probe(struct platform_device *pdev)
>  	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				  sizeof(dma_addr_t), GFP_KERNEL);
>  
> +	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma) {
> +		pr_err("%s: failed to allocate DMA address arrays\n", __func__);
> +		return -ENOMEM;
> +	}
> +

Hi Guangshuo Li,
Can you check on correctness of inserting that pr_err()?
ie. does it fall into the category of excessive OOM messaging?



>  	rc = ndtest_nvdimm_init(p);
>  	if (rc)
>  		goto err;
> -- 
> 2.43.0
> 
> 
