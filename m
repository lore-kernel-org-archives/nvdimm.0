Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFB733C1B4
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 23:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780528963; cv=fail; b=Ov3qBBbNP80wFJiBMyOmh5Xi9kIYUnT6qAqXtJNJZJ7+SaQxMfpmfosSFZsInfYrwO0Wi9DRv1Iyhx//UosufDW/k5ox6MoZZUh74E1blPnefpzo5o5lmSTMXoXj371f1H5uGTxXwbQNt/DvV/nOIVk8v+IrAGIXC7TxfwqUbog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780528963; c=relaxed/simple;
	bh=KQp5lPuRVjNect+ZJ/SIzI4g2l51+s0QLGHPQCUkUG8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M2lOaA1OY3sTprMA2UFJq0sR5rakUGzWNKplOK3uj+paRUVgrqruPOgS7TU/uGu74tMGtppSisR9CiDif9KOEjMekV8o92C9XlWCBJgNXjuLVIpSfroSd2zBmJ2xP/wMOw2MI1gpH1FVPBwlcW0C8fZfA/qzWbxCN7BklPntQOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fp1hDpup; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fp1hDpup"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780528961; x=1812064961;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KQp5lPuRVjNect+ZJ/SIzI4g2l51+s0QLGHPQCUkUG8=;
  b=fp1hDpupKKPGI1/v+u7Fmp+XGXkTY4wNl7oaYwiC/Fs6G1veWqfYob19
   RVgFB23Zi/Itm6wwF93LKiBjPCo+RA6gn9/Kt0shMwG3FbWWCw4WtmVuY
   pZlDFGUuBvQP2JSztkh0nbKyEpsPX8PIT8St7zUw9AJ4vLXgbpz4SnOhP
   f+joke/+ThkfpouvtLhJWSqHwl5S5zMIsDfBEdEVy0/V406dyWoyk5Yno
   Lxqldy6f/h7YSTnULW8WaX5WrgHmvFBvqS7p4IhX4/3CVeJ74N5gIdgS6
   5R8T324rIQmeME+fMfzhODCRKxdp2LIGyngUOVRGv87nWEDSm/Vv3YoWN
   g==;
X-CSE-ConnectionGUID: bml6wQu/RYq2d5GV9ssXfw==
X-CSE-MsgGUID: bnWje4ftR0uSdnMprNO/Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="85241771"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="85241771"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:22:40 -0700
X-CSE-ConnectionGUID: TyYOkJfRTW2ATKIOE1FKpQ==
X-CSE-MsgGUID: vFXP/Ur+Qp++2JayYU0NTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="248328313"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:22:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 3 Jun 2026 16:22:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 3 Jun 2026 16:22:39 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.18) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 3 Jun 2026 16:22:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9wPYQO0kVXt/DnEpDctE/56dsvk9HXjHYTBhZd6atPqahzRIo6eVUe30i3fUybSYaWIhs9nnoVXrZ7vJNpugP2bH4ugKG1KUKcatb8NxgYmhJO6ogTGqoLZHeXQ94/ZpTUJyaLHhUolTk0trTznFKdaIP690Am3j/UzJru82TsJWthvxLWRNRVMkKEKBpVPxZqJvFkUIEOSAb8i3uu5JJkTTgqHKlrN6+Ua6B5lIC92c7xr4H5jVP38qsmdcipHsxUeHl65tPlT+YJv415nPZohTOALAXJLu68VFamKdKiRwLjs/M+px6ft0fYSw68Bf4YR4TEmSoS05/SnktsoAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZtXxojeMU87AHWNMLyBnsUe38eXJoHWhvwax8Ad7cc=;
 b=vxZLZ65MuqDk1hKldTq83o9+33ITnFgDGOBIDdy9pp4kLIJOI9T7hwFvI8XBf/BJEW9Nn5JMM7JK5N0NL57NF8r/ycpx6v1/zP2rl7zAfqRWhbCH6ybsQUSARnFKU8wmHW4EvXx99WMaqbyR5wbaTVSCxN9xJLfjPvoF4yXKX+M9u288AeO+4DU5BntoL/yDkcrE+A0lg0JT2iXpKFSOdPGrl31+TRgaQA/ISaN8mBa5dwFxRL76m55iuQgkAoxEqz2w68DlFsGR3OBe3yad1O641VChUh/S5JZJzghKiN6YTgf8B/5lahc71spFAcP7S5DT5lqok8sqZQFNLvX3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SN7PR11MB7020.namprd11.prod.outlook.com (2603:10b6:806:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 23:22:37 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 23:22:36 +0000
Date: Wed, 3 Jun 2026 16:22:30 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test/btt-stress.sh: add stress test for BTT lane
 race
Message-ID: <aiC3NolKOumEMGk0@aschofie-mobl2.lan>
References: <20260424233633.3762217-1-alison.schofield@intel.com>
 <29e5bdd3a3f0e4c342f7ed93808fa06cd2a96872.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <29e5bdd3a3f0e4c342f7ed93808fa06cd2a96872.camel@intel.com>
X-ClientProxiedBy: SJ0PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SN7PR11MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: 15bc3fbc-f1f4-451d-32d0-08dec1c6ff79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|6133799003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: xeQ5Bsw1NAdgcIE61xeugqLaI3TrZirj47e5gSZaDYZE7LG++v9Ny3UXlj3aI+dsLcYRcvKrisfVwZi/LTo3td83TubAvsvWxSfJ1bhKlyx09+0RqJN8QwGvd34um0T80fBrewMNnK7wie8tggxXxQCrPboLjSBaPH9jRsarIl8OEjdUQK8gihSQ+XJ2/zv3RiCBrzNg6hAxCslFEFpAfynRXmg9PIBnkqjLOO/TAedbr2lPLjvRYNFFRZC3LGO5eD91t0pxHKLKhG6evC0Xt9ZCc7aH7ad8WEZSZO0l1ixUEApyKl+bQ8tBHmtGJANeb3rTLwUK3iPEKrSlE931ACqC/T2Gz+32xLNfoiDek+p5PdtkhIJWuevQoYgyc64HyuvL/jhKu7sDlLvJvt6etzZNkEScGNYXTH1Z4YW87Zwr6NkfQtZWmriaDwdWXf/qxEFNsbIxa6lku2hKcOAlDPmcY+PiOyI3eTNbvuETgkIGhMZjC03eOUs02T2vtiZLKwd9zef8IB7knI93Rebwe4fAoThKQF+UeeY6CXyelzKtECDt3cDBntCT/2KGVGbX/5NKmU2MtvCMmn5QnoXxNDUQQmdZO1ajjUoEtt5NTTbyPzU/q5vMg9G2jdatiYxDscDeAXBXPmUQ9LTxmBtuXML46w/3fzphN5T6OnNnd+J9g7UThYbfuYq9uXhfwIb5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Ved1e2qdglM5jizy8jotOh62zAeMRpTEOB2UCshvezhpbwYytVRbe5JfRBl?=
 =?us-ascii?Q?6lXjvnJzAcj9ZuFVT/aaKp4wky2l8t7Bnt9EBUC3q4ULs+FLfCoenNziqlW5?=
 =?us-ascii?Q?6NSgsolEUJyksgsdnPuTvWwDVY0x64hhBfKO2tzmjClDypkj8hqPosRi+d1B?=
 =?us-ascii?Q?zlw9TFkbSpwAMUvTuQzzeYlmntq+rHNBLh8Az66hY1ReL1jiVGh9bdL75c8I?=
 =?us-ascii?Q?sK7/1A4OyJLxEp6OrOXq8n3n+69Z2ebVNG7askyMdDjhhUkSSvqUEbXkIRWV?=
 =?us-ascii?Q?H/XtJvq9Qwl9/d8dbHdKN5hpv8aaojFMBRAX4DXYLwNaJvS9AaHq/Gtr3AuC?=
 =?us-ascii?Q?K+UEzTgXJct5IQeT193eG1nD58fjk5CKnp0D+QL3a1dBLiHsRMT5mLbSFL9B?=
 =?us-ascii?Q?izSY/7hebpHdDzIlXrRSe8Yj8dKTWxip6H5ls5Cpw0ZrNFVcFfBtmgPsfZqW?=
 =?us-ascii?Q?W30BnNBVPMawDZQM1hpzrT6jfO3Ik1bKTnfLwZGUBv1T4PVIFcw1iblkmyHH?=
 =?us-ascii?Q?Di51VbrIaNxK/IPE//wqHI0Nd3I1FN1VEpvicsyxxziHjKYVpifHkcpL4cFj?=
 =?us-ascii?Q?CCM6TTrei9p9/Eb9vm4XCeYDFZXlx+MBSy7TgCbWUiQGrRHLFnPTuLJtVstz?=
 =?us-ascii?Q?0JXhaJ756//40s7qy0rjWkZsmB67qsbOWN47fbxhtI4ZDBRyl2BMMSLzvq3n?=
 =?us-ascii?Q?tak833PZOBgvmkh89VVSz64BNgTJCH9/srrhue8gTW3BmXWjfVQGGwJTBjH9?=
 =?us-ascii?Q?rWDOoP3ZhFTSrZmZu8wwVEfJMh8sDKJGDPwH/oTv+H31RNchu8dFXyJTil7E?=
 =?us-ascii?Q?oiw2KkIj/MhwPdu2KCq/8xmKZavIywgjaIcpkLlkfR/Pf0y6liHVaDKL+Rlv?=
 =?us-ascii?Q?jqJJ/f/Bpel3JlxYgfe1SZBsIohep2MU53JkYMZRcT4lSD1hHfdTyKKMT31s?=
 =?us-ascii?Q?tlgE7gQ9GL6Nx7IF55STbKSzZBHX7K/wWUsdX2stCcfEN/0AMECGhyfyYKlD?=
 =?us-ascii?Q?CJFWexgoJl7wzp/Tfv/MLBowGULLelSxKxYcjksC7JQAkR1CpyXj6yiufDun?=
 =?us-ascii?Q?zihM7l6B99pCJ8WZXF1ysA6/nGYEzgrXX2AI/YJGAnRl2aiuiMs9Dqyijd6n?=
 =?us-ascii?Q?1fuNrdJSW3KMePyflsPDQmrTl5plaEsJArs0v11ZbAq/SsXJXOSU5CgYpJYe?=
 =?us-ascii?Q?5GQeMNTPd7drdR4R9XC/rjPwoXkU5Oz8a7OPAwBMLyex3r9ow6pcr23jRcNz?=
 =?us-ascii?Q?tNAZNpGnmhjg0ZRwdhK9bNdkmic5P9h3aUFAcVyYUAN7+Km0Cw+e3mwqC0yG?=
 =?us-ascii?Q?r50lOowqd87R1CK2hhaAcxC7MxbQhlX00JdmE8rp+9t/tXZobqfeBoIMp+g3?=
 =?us-ascii?Q?7VEi7L5UoAEmZmJZtdE2IkgKUQ3ymqC86flzJFBI+IxJZMIxCEfbtOBf+cJP?=
 =?us-ascii?Q?/ZQarGkdFp4lj5WpSZ+EYTCvwZ3rdHnZQjJNCZUN8tRJd3+1I33P0Cly2G9V?=
 =?us-ascii?Q?Nfk5MY9iUK2Qv8+QFTqoCxK0l5TVZIZlj98E+DBOP0mxm2p8QrzIiaiVMsAs?=
 =?us-ascii?Q?aeRiXMf2ipKY+0KNCRo7+FRwEw3H0fZ3aliMF/mUTMhKLY4Al9qgecUggqoX?=
 =?us-ascii?Q?vxSnpTZmvMey7rm4GB3rHN/ZN2Ej4KPPCCTJlJUevElBkMI6VtKj8YFaaSKc?=
 =?us-ascii?Q?uzqV8FcvEPDxqGfcEbEx4y+ZpgAS4f8SJ7grurQN4Od5gXl7/dVY3BnZ2Ols?=
 =?us-ascii?Q?pciWJEN4iQ1FG6h3gfoYeYQ/qrG3DT0=3D?=
X-Exchange-RoutingPolicyChecked: Mc0P71p158KKXzrVMYdW1+eIO0wEOmO1f/D3Sg1M40zP1pXueQN2rogR6DCMTMm+f0mq5Jztu78dAx3Cd77WUVmYVSZ1UEHoCMKvkGwlaf0V1TpB9kKe5ywNHlLpXCVFpU9vvfrGu8K5qpXMBdl1ZAVyNHJ3s8HP0a7FubnS3HPWpiEZTLVe7lgqgMIRkr6B9EY+GEyf3P21xNp8JYWyObuShxGCBM8twKTPVwCZbj77tQbH9mNVDKC/UOQGBjNz4b0U66ziKx/44gvEEagtxiKGMIEm8nl9yrlHpkxsDbAMqMEejXNBgQ3g3h1ASq510i0L9QDTHv6Ep3t5rGhQzA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 15bc3fbc-f1f4-451d-32d0-08dec1c6ff79
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 23:22:36.8743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xQSGAfJoMz7ZJBvNL0QuKNuXzvTCXN1tkAyR5+r1x87sJGlfiWv3wFURRaDFK6NbQVqJBQGmZ+KBz1xPFzPLXE5/EpUkvbaIlQ+Z4KYCQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7020
X-OriginatorOrg: intel.com

On Wed, Jun 03, 2026 at 12:04:00PM -0700, Vishal Verma wrote:
> On Fri, 2026-04-24 at 16:36 -0700, Alison Schofield wrote:
> > The btt-check unit test exposed data mismatches during BTT I/O in a
> > CI environment, indicating a race in lane acquisition that can lead
> > to silent data corruption. The failure was not reliably reproduced
> > under typical test conditions.
> > 
> > Add a targeted stress test that repeatedly writes, reads, and verifies
> > data on a BTT namespace while background readers contend for BTT lanes
> > and CPU loops increase preemption pressure.
> > 
> > The test reproduces the race on an unfixed kernel and passes with the
> > lane ownership fix applied.
> > 
> > Assisted-By: Claude Sonnet 4.5
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Just one nit below, otherwise looks good.
> 
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Also, side note, looks like this ran for ~45 seconds on my laptop making
> it the second longest running test in ndctl - maybe that's fine. Also
> all the 'while :; do :;' processes pegged half my CPUs to 100% for the
> entire time, but maybe that's also fine :) - I see that's intentional of
> course.

Thanks for the review Vishal!

ICYMI I take unit test time hogs very seriously, so aside from the
obvious finding here: you deserve a laptop upgrade, let's look at it:

Alone:
1/1 ndctl:ndctl / btt-stress.sh        OK              10.71s

En Suite:
1/24 ndctl:ndctl / libndctl                       OK               1.76s
 2/24 ndctl:ndctl / dsm-fail                       OK               0.30s
 3/24 ndctl:ndctl / create.sh                      OK               0.41s
 4/24 ndctl:ndctl / clear.sh                       OK              14.70s
 5/24 ndctl:ndctl / pmem-errors.sh                 OK              13.61s
 6/24 ndctl:ndctl / btt-check.sh                   OK               2.71s
 7/24 ndctl:ndctl / label-compat.sh                OK               0.58s
 8/24 ndctl:ndctl / sector-mode.sh                 OK               0.67s
 9/24 ndctl:ndctl / inject-error.sh                OK              13.99s
10/24 ndctl:ndctl / btt-errors.sh                  OK              24.14s
11/24 ndctl:ndctl / btt-stress.sh                  OK              11.15s
12/24 ndctl:ndctl / hugetlb                        OK               0.32s
13/24 ndctl:ndctl / btt-pad-compat.sh              OK               0.95s
14/24 ndctl:ndctl / ack-shutdown-count-set         OK               0.21s
15/24 ndctl:ndctl / rescan-partitions.sh           OK               6.76s
16/24 ndctl:ndctl / inject-smart.sh                OK               1.41s
17/24 ndctl:ndctl / monitor.sh                     OK              49.71s
18/24 ndctl:ndctl / max_extent_ns                  OK               0.79s
19/24 ndctl:ndctl / pfn-meta-errors.sh             OK              14.79s
20/24 ndctl:ndctl / track-uuid.sh                  OK               0.55s
21/24 ndctl:ndctl / firmware-update.sh             OK              10.32s
22/24 ndctl:ndctl / pmem-ns                        OK               1.04s
23/24 ndctl:ndctl / align.sh                       OK               1.13s
24/24 ndctl:ndctl / nfit-security.sh               OK               1.27s

To be complete - that btt race condition took a lot for me to
reproduce. I was stripping out all things that slowed the kernel
until I got it to hit, and then came up with that level of stress
in the unit test.

I do wonder if you would even hit the problem with the monster config
you likely are using based on your runtimes. Did you test this with
and without the fix applied?

> > +
> > +create() {
> 
> Usually for other scripts in ndctl, the convention has been to be more
> C-like and put the opening { on the next line.
> 

Yeah, this is a thing. I've started using shfmt and that brace placement
for function bodies is not a style choice. And when I think about
enforcing it across the unit test scripts I do see the C like convention
you note.

Let me take a look at how the kernel scripts in tools/testing deal
with formatting. I expect it is some flavor of checkpatch.

I'm after uniformity and no exceptions! Same thing for shellcheck.


> > +	json=$($NDCTL create-namespace -b "$NFIT_TEST_BUS0" -t pmem -m sector)
> > +	rc=2
> > +	eval "$(echo "$json" | json2var)"
> 
> I was going to complain about the eval and the json2var 'sed' parsing to
> get stuff out of json, but I see this has been around since forever and
> used in a bunch of other places.
> 
> Ideally this should just be multiple jq -r <filter> invocations, to
> extract each variable - more wordy, but avoids the eval.. But this can
> be a future treewide cleanup.

Agreed the eval/json2var pattern isn't ideal, but since it's the convention
across the whole test/ suite, I'd rather not have this one test diverge. 
Happy to do a treewide jq conversion as a separate series.

snip
