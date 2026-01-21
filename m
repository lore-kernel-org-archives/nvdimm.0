Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE77C2C234B
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955920; cv=fail; b=clkKF05RXW0NEfWJQ+aAFImPT64UBfvgBgz8HvZEJPklksWK0XAjXUtQJbSlSRfnswMDodtAinYs4uPMgoD1scAjY4xCmm6PkrO4F2arSCqdevIjRJswmfp6sJqKGS2yqMHUn6JmvHfwZ8svTiAJlD6xntUan8aCfujjQG+zUSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955920; c=relaxed/simple;
	bh=Q97uLFPRMjgTsiZJOG+sOrETmb7GBmuvztJ9JrPe+4c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=je0VsedaMcAnDy055ARxWWn2g7PRG3aFyLta7lQtMi/yaqrRS4wAnWGHpCqJTjEhhP62T4V8s8+bp6xi2Zj7KdBZvhnO9tNFPvmEuoXJnSqNz8FatnTlFzN0dUR/HCH9edSngQYNERbeUZrAzu1XEC8xGZy/XjF+gHhYhaCusok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DmZk5Lqi; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DmZk5Lqi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768955919; x=1800491919;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Q97uLFPRMjgTsiZJOG+sOrETmb7GBmuvztJ9JrPe+4c=;
  b=DmZk5Lqi6RYLjp1H4JQLPu9rx2kCoVhWUW/OoDdjpx/QdCRmedcjunOi
   Rq3AQ2I+9eHQxazPCskaJxa/JoCK/e3rFhrQLwpQ+WYr4Iajd5AxAsKoE
   H4K2FJ3/RQN6fDfleYONf3CEz21ZQWMyDpnc84Y6+nwDOePeY3lAALzvo
   lNhuo9qmU48v940dFhllOXGs3ShU+sqV0QGnqvy6nHDUSGafzAiQFSZDy
   TpaET2flnEk7exGvk6+KJAMzEVzLl0T4XwnMLfp1wWvx7Dx2a3DSJalC9
   Eo5q8VY7BbYIPYGCLTKA6P3m3R4sjn6SEdNpaHwgaQSdmdKQOTdw3zt/D
   Q==;
X-CSE-ConnectionGUID: f9W99/3wQoCzPw8Qa96UgQ==
X-CSE-MsgGUID: +f8WKMPNSRWWAf5/L1P4Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="73806224"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="73806224"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:38:39 -0800
X-CSE-ConnectionGUID: /N/M2r1OQPOCqdXEkt0nJw==
X-CSE-MsgGUID: hZggHEwRQtOcutv4CrfE2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="229233506"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:38:38 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:38:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:38:37 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.42) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:38:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RCHLAVtR8HQRFCfvLwQB97NGmNjDYj73ZxY5Lv7lYvs5vH5Zqahd6ted69JrMRevatPCFci2KtJkk4wfqQabSE5CSqDVuPx7Lh4qeu5h5WY5S8/anoe5ZwusT8GdXpe9NU74MkSXeHnhXFEdt+Qg31jDgLhHKK5Q0hSMn79HcgjGKTXdcIi+wqHSZ06fzg+tGzBWPrzNsWVScluRbitp9oFcmnSMP/w+KxfMywranfAHwZN/rBFi9DHhc99wyOuu/N44qJ1zvdkwDkZSeHw5Oj3D64P6AeyzfifJHq7+kI3D1WT27V40FZLH7HnOU1WwJMED16FVwr5Y6poccJpsvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHADh69e+eZcONnFRNT9KYMVE+/Sag468jCYeKnwX4g=;
 b=n8EXaAw2VZ23q++K1UTF1crN9BMxNELwlT3HO7fFvGv+M3e2AzDkiHI4rQwrUsxknSr8M43E0nI+nlO8Db6vIcuHl5obTSGjv2Yz3SsYIk6u7JP9Dx8G/nCY41Tussbg/GsSJbf/U8gsIXDKOiM80W9AYB4T8zZPLlcmT0d4D7v3+ecWKi93P7qz080Sm/UOg8we0RU6qahG3vamTcfuHWeuBLpeChZAdbUUu/0AubAM8hPkBK0Zz7xVtUZllv6N83gfV4r1mhVoTgRsv06Ei7Nxi6S881c6LhDT10TlgO5DxgnfAuDi7GNJs6AUhGKTjnU/xspLZjXuMJTdWM5MOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 00:38:34 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:38:34 +0000
Date: Tue, 20 Jan 2026 18:41:45 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 05/17] nvdimm/label: Skip region label during ns label
 DPA reservation
Message-ID: <697020c95d699_1a50d4100e9@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0@epcas5p3.samsung.com>
 <20260109124437.4025893-6-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-6-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS0PR11MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: ad896478-e6bd-4958-24fc-08de588568b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s0WQUZ9yCPAVlyPWYnenjMpMWPjdF/x1OAfla/i+K8aOozMX9GhGCbVgijDc?=
 =?us-ascii?Q?t3kXKFhnmHuy0Qh9EFqIFiyee7FN742LCuyVWyoLs0I04/dczxW1op2BwTrS?=
 =?us-ascii?Q?2piE0TJ1Ei9T7kpmUf685wlvGrGk6DFTr2xMzNaqvLvajX9yvBujCIusfw1A?=
 =?us-ascii?Q?ruhyGwQsNMITjSDtVer89yQnJmBl0G7r+Jo7huC3vNEK4/8I3NGzzAWEZqDV?=
 =?us-ascii?Q?5+qCli/Uu2vJugE22DXikqwLvoYtUQ6rcWi3P2P/aGyj8wsEWYFfLifC7BLf?=
 =?us-ascii?Q?UIGtluoh9VCE5DEWa0HOM0CkEOJUNu7aEtOuKGPUS5YDdAH3lf3k6l8EcREz?=
 =?us-ascii?Q?nMop5A5v48eNd9rpk4s3PDyHNWVjJrpTGxh0pnLG7uhgyNoMSZclZ+Bx6JRW?=
 =?us-ascii?Q?EcyV987ynzNNmSYsccZ0Km53uZdzCOoVeXOcVUe0fbD+eSoartUs8PFD7ssP?=
 =?us-ascii?Q?UduLNIHRfwrQioo89E5IQ8Nw9ELfel79U4/a3gyBKV47n3TnC1oew+a8+w1P?=
 =?us-ascii?Q?JSTGGp0tfir4RZ6HzcKipvB4vKOPJAt/8lKpImDzLzpd4XjdDc6EFvxznQ95?=
 =?us-ascii?Q?tlBcmHHOUVBV/jIcVtaOHKRtQScllm8nFLQyfSOjN31FY3vL08Nu/OBOvowa?=
 =?us-ascii?Q?2dZd3O8j6Rtu/9xy0jXq5BwkYag4bNjiLzMcbSVQOqvt0JrLfLoJ62KA0FdQ?=
 =?us-ascii?Q?gV0sysUr0qUEnQUe+AgtJ/3XZvUwP5SJzrJz7b85Xv7+pLh6bveHPBhXwlEu?=
 =?us-ascii?Q?9Upu6I/eRbuoxZL0Z16cXn6vjmzYQdBLjzRTOhsiPY0FIkcsla0qv6sQCGHE?=
 =?us-ascii?Q?9FcYDbfC9RRtT4tGZGWCyjYDW7pNqobM40Gq/VaafQwiFMA7UfZqMjrBTLaA?=
 =?us-ascii?Q?R8AFtyW0zNft7NEw0Tk9df9aGDA60v++mlMxhYLaY/Jj1UxfExjbvo3mFzu7?=
 =?us-ascii?Q?j1rYN3hZsXH4n3ThAYUZe8pr29Lp9ELv/Tu5+z03FIcD0PYtutMGEi7B3PTE?=
 =?us-ascii?Q?fquaGK4ex97S4NImf4VJwfveXLrDCC4c6jgntOAMHAilNDlxH3azaUkiD0tK?=
 =?us-ascii?Q?bcrCZQ3ndAz+tbso/Gz0qXIIttgppFpudyvRPbkYgUhrW1x8SnW39hFLSM5G?=
 =?us-ascii?Q?19K+ajE2QswKkZ1kHGdreVSKC64IFTAr2T1iWHpykl6ZnplhaK4qXCM0e9yW?=
 =?us-ascii?Q?nmFY2lV0an3EMp0BGp8tQHgutbvsMPvss/NWtiWWnH/YIT5cuLHGeUxsYObp?=
 =?us-ascii?Q?CU9TpTOYeS7C7eQRBoRtxthxO71bCxuq4LCEXXzrCrpvMEGFMR7+sP+XMjNV?=
 =?us-ascii?Q?mW6lzsU6LmsC8Jjv7mYP1AYSUYkUoKp/cJKuFvZUpwlmf0rb7emWh9rIlomW?=
 =?us-ascii?Q?gM73Iv50nQUyN47FH2gLkhFsSINjV15pb132u4Y+rzK1d0mIj2j+ivWXYOXP?=
 =?us-ascii?Q?uJsGZY4EwhbYzt+RB5pMWMEBVhfWoCuXJ7jiiT067TMK7rWtood0nddmaIby?=
 =?us-ascii?Q?4ASIPYnyru4LRVoIJUGIPuhlDYLMS8EH82sHMlPQrF2719InQm1ZrqMyrOIh?=
 =?us-ascii?Q?cHL5zr+1F5rt6zTkna4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6PB2ta7uKMbX+7wK3EGs2GRJ6R/RVOvw/Of4KFMaHRfh86HuAKV19SaxAGKz?=
 =?us-ascii?Q?2Osp+4S7LkqNuZIZbrrsXVpqGLDQjzNvYZh5RBfz6mo+dWhBR9xbCobjsZtY?=
 =?us-ascii?Q?2dJAqmz3jmhMazLXOqOpMoDwpFtGrEE5Z/84FIjSGoXuUa8HwVIGrwOKCSJf?=
 =?us-ascii?Q?7Mh6DgtH4JS09e/FnsQXW3XifAQnmm1zxu0AvKY+JSc/DZkGRfwGX3wYZTLh?=
 =?us-ascii?Q?U91dfy6LTm4xDVXNbokzWOj16FccKgGYsObd83nFfYH8bJ938VwohwHPqEw/?=
 =?us-ascii?Q?T+G4inndvyMMKpXjW2FHtLpAnvTZcSPbMY2HRHReIaXQxX0ywExw0wamnH5l?=
 =?us-ascii?Q?++fpccGddBsFqONqEPGJMxiVT6y6RH7jjXgTrgth3yjTTvINaSyG9lRLErT9?=
 =?us-ascii?Q?wQPPt/XG0wOCJEWD/cq99E4eacgatUMWnmh/T5F/LS4fX1ZBd6jK/y+biWl3?=
 =?us-ascii?Q?ERP+RH5bzwz8THaku4HCUlUtaOjyueu+ZqLnMpMUnlMWK/42Z5awPFVvEVgC?=
 =?us-ascii?Q?zpKUQzoGqkyyUW4h5RcSrilRXZIfWtaXd8BaJErWaVPHpXtpEtp7aVe8//pm?=
 =?us-ascii?Q?TQ0zCUGZz6iw2uLuYW2TFbgKm/NWbrcE1FRtejm6PDGPpy8fTO3XqlNFqfOG?=
 =?us-ascii?Q?CVbQvZiF6T59/iQ6ofePmNOzkxPiQdwFhlcMoyb0EDS/SuHjfiabyvc0rARJ?=
 =?us-ascii?Q?LpEn7lzbLSpNqhA3ZilC3X8TyjeNtbR0+C9iayBzWVmbiB19PzQE6qFsPqkz?=
 =?us-ascii?Q?uX3sLvnM8G3Gu9sTsYP10eR0lDogC7hjSGCX7fZbKFe5NXKufMnBP7iehPFv?=
 =?us-ascii?Q?BJBj0UwYVwxP7i1K//r72L734O416QCHwKMIDm8N7R5+FOA0c2sOzTTXzyn5?=
 =?us-ascii?Q?A6eOjsxoLMmXeHcBPgDgq9Jj/Eg+rDJcXdq+ZxdXYTqBH1ihTAtDEkrzSegT?=
 =?us-ascii?Q?IEXD5vPyGz77ux2xojr7kqy2a1VQXUAU6UdMRJaLrV2zVNLi0/ltLh89a3ef?=
 =?us-ascii?Q?Wkwk8mLPNlO772j5tv17PhfRod2mqrNNubZ7EFfTqcgCgpJHO28ktKrHZ/Va?=
 =?us-ascii?Q?4CkhxZwMj8hQmvJEjH9xg9YTXecgiruBG5tLKkCvSoTKwco4bGh+U4BjTmJc?=
 =?us-ascii?Q?UtCiP2gAWNpRnIS9332AWsnQUcJD4de212tgKwCbEF+F3WkrsdZ0A9xpYu3u?=
 =?us-ascii?Q?u9MbzOLd38dkhDmDaNRRAxMQWrv3/j5IeBa9v39lQBlBfGZAHoZ7HFwb3uRV?=
 =?us-ascii?Q?GDQqHKb9BHyBAxxokRCiZrW88SqlwROgOBrVZ0TkKoiYDacq7LXuqgyWjM3U?=
 =?us-ascii?Q?jb3bpcAqGPLuLs07YSArqbHM6ufB8HOdhe+zOm3/wefIagfTuL7y0ZBHLmsh?=
 =?us-ascii?Q?ICJcyf6O/5VHXueBdcRm8uefSQlS+pC5qzu1eO2yEEdVRthBGP5pY9839pwj?=
 =?us-ascii?Q?D/RVEWBUuHVQSTM2nlRCXMqGDm56hKdMs1sszlNnUCsLJzizngXAlXsyb4Ip?=
 =?us-ascii?Q?vAU5xZEpOBneVo9L2+HbCNATRrBSJztT0qb7/0w8yjWj7bnGVQIrcQKkhMNl?=
 =?us-ascii?Q?ok/Lnq73g4T563fQCq8KvodsMKFvffV8YT9ii2ODUjDhQoJ5u6lRymj6+eUz?=
 =?us-ascii?Q?XYZY/piNstEBKjpTUle1eloeb/a72U8pB3Thd7M96B/av/foHPkiz1IIpgG8?=
 =?us-ascii?Q?1dh59avFZp0VS9xfmxpHi/MDVDdigDNzqbJQJls0vnEVg74Mri0WuV5NdDJA?=
 =?us-ascii?Q?c/LXcTaF8A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad896478-e6bd-4958-24fc-08de588568b1
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:38:34.6018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YKLMR761oNldUXlzn7XtUDIVx9WjD05YDolsvvMvIRkPb4+eg4ggxaUDL4ZSFboNMJ5fIWPAoP2MrcJ2fHwMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section
> 9.13.2.5. If Namespace label is present in LSA during
> nvdimm_probe() then dimm-physical-address(DPA) reservation is
> required. But this reservation is not required by cxl region
> label. Therefore if LSA scanning finds any region label, skip it.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 9854cb45fb62..169692dfa12c 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -469,6 +469,14 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		lsa_label = to_lsa_label(ndd, slot);
>  		nd_label = &lsa_label->ns_label;
>  
> +		/*
> +		 * Skip region label. If LSA label is region label
                   ^^^^^^^^^^^^^^^^^^
		   This is redundant
> +		 * then it don't require dimm-physical-address(DPA)
                           ^^^^^
			   doesn't

> +		 * reservation. Whereas its required for namespace label
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				This is somewhat confusing and redundant
				as well.

Simply say.

	/*
	 * If the LSA label is a region label then it doesn't require a
	 * dimm-physical-address(DPA) reservation.
	 */

With that.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> +		if (is_region_label(ndd, lsa_label))
> +			continue;
> +
>  		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
> -- 
> 2.34.1
> 
> 


