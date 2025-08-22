Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ADD4A3E
	for <nvdimm@lists.linux.dev>; Fri, 22 Aug 2025 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755822080; cv=fail; b=ZqXaYckds70yb/KaeB/Ql46l6KfMI/7c170HQNhvnmqgJuuuP6FCjke4NA+iD8VZN1pNCAKEwLzcWsTDp4J4MmS9mWDAaBql/3hC59nzsIGvGlCfCKjGbDL15U8cQY/pXqsBTT4hGKJ6PP4CmlY7Qh+o4na/so4tucuyGQ9c7ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755822080; c=relaxed/simple;
	bh=Lo49ITPIsRLE0z5eYzIlb3MStKjpwIMjGDnSgO4OIcQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PrBXgZdAEt4g8KFtrwkc0gqQGyQ3iFyi1cN7+Q/HYtFGZj9WrsHMAlohpOL9SJjRYXhuf0P1MZ/KRTPdzpQfMteKF6vgAln3KVZHfRpM6Yt66fvGqRjFzThmq29RpurMaQUqR9wC/PNXzh+ox5kJ33U0mUqP7BXX1ND4vcy+Hpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTMqKNjn; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTMqKNjn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755822079; x=1787358079;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Lo49ITPIsRLE0z5eYzIlb3MStKjpwIMjGDnSgO4OIcQ=;
  b=TTMqKNjnYBeMB8aE2AcoXX44ewz6kUCqXzuN8wjbynbmvnks/UekGDgg
   eqPs+7/MV7No9sZ25ABq2UAfnpq8Zigr9Tw6zgJ+CEbRnNrbBe3soxEgI
   H2UcIIpUbz/1BHacfpwGKH0vDSck+vBO4/kCqO4anjDsgWc3gbu4/QJms
   RmT1MyB4FvKQxM9j2q0S2thcPtaVy1jlHfpILYGIxf8YKH7kAYirOMnmn
   yQPkUKcp84GnkTQ14bhsfjP+g9AVgTVs5SIJE5318nTGcSIctjJke4iHl
   4CIdco4wmC/2h6HaA7mPZv9jfwaIKQ9NPbddZdSDopEQJUu7+k3BqSX0c
   Q==;
X-CSE-ConnectionGUID: fmj0V+rCR7yOZIHw33VHgA==
X-CSE-MsgGUID: 3wbYoMHDQyKVdisjP7u1Sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58075999"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58075999"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:21:19 -0700
X-CSE-ConnectionGUID: RkVs2DPFRUi8S7+Au+wxGA==
X-CSE-MsgGUID: NNgABfJVSdWWSYHWjQvKIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="169370130"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:21:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 17:21:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 21 Aug 2025 17:21:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 17:21:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xjAndomB7H2aX9+eUbhuvJawQBMvri98MpCSAr1d5GMMHI1bR/QgzTQDiB4gTRD9vvU/3rPC0tvPLC6oiKjU9fFXMbw/V/hwCXd4kb11Gu9+hmj+mbpkZMKnN/FczKqdYbS+TWYz5m6o9Hskzjh2jFHdGK33zZ2F8qbYp8AubE7wfyhf8/H11j2PLuVW57uCIxBiNKmPlR8B+drAG8FskIeMASEh7ZdR3oIT0CpUtudNe+9lc0DUyNaPZyXudHACLGBdTmLW+Jd0/WNhLQVCZqTfR5clNrMHjfYI5oE/DQFkL2VMemadGmHfnJPAXzpGKV84OmDoY2msYyt/Mdx+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hwoZhbs3WGNQCNJTm7NKnZ9RIpWn4OPvseVpmD+PH4=;
 b=tkQlC5TfzUsriAv9Wtv9CxEncaAEu887figadNAcFzLmg8OmjTTm/4vwmm3+arP4T8aX44fthhzNwVfVV3PoY6rDT26eDAa55TZ1UQ8lMFt97DLt7604IS1Of6ufyBJ69aM0Ej9O2atXQVAZZmMyfYh7uV8Ws/LwEiXSs1XMqHbzXf77AXcV99C4PO4aWR1n4c6yZAbu+yS7KbnC3JRiWTwAF+wumdcSJiBeYM5MHNwVzhdurUfo9TVdpfxQZelAHw6F16Z1x1Xw9f3/h9z/ZwXw7cn3N19BmsvPpdwt8eo83ZvKq1WiMjIyeUDU1n157pku0gDwxN6hQRbQlOwikw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by CY5PR11MB6138.namprd11.prod.outlook.com
 (2603:10b6:930:2a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 00:21:13 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%7]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 00:21:13 +0000
Date: Thu, 21 Aug 2025 17:21:11 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>
Subject: Re: test/common: stop relying on bash $SECONDS in check_dmesg()
Message-ID: <aKe397XaG0376Dgb@aschofie-mobl2.lan>
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250724221323.365191-1-marc.herbert@linux.intel.com>
X-ClientProxiedBy: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|CY5PR11MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d20ebe6-9f15-4bdb-0622-08dde111cd8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zWKwkcnAMG3frqPeKuYBEgdY795DISTotsUMLYyV+nxyF7t1x7Uay14CArN2?=
 =?us-ascii?Q?phOne2UUwruSVoT55oH7ZaVDmWouYRICPRxiLPYYDS7Lp4YOuOJ9m7GCvZO5?=
 =?us-ascii?Q?vpR7iQp04ftD1xx1Eaiin4jNEKNQm2vGmAcYgzE6cGZpGoAvT/7FlvT2Azu9?=
 =?us-ascii?Q?jADNep40wYPgeY1/5ePA7QmVlTyzk0D0jNLIy1Jg+sG7SvlUCady7J7YIWar?=
 =?us-ascii?Q?Ca9h6akkdGRx1kH+36IQXmyOF2qHThVfwa1ulVs7AGBYy0vQeLEX9RxAAfjC?=
 =?us-ascii?Q?bSLwps3Rx5cGxZQWn3X2gnzv4ovfqV0wNCxSxi3FLHGHXQhuSCzei3l+FG8q?=
 =?us-ascii?Q?rqusDvo3bC37L+SQFDfClBeDyfkaNOP6JWiZRc92OJ8Ql+Nooh+DXFcK25ns?=
 =?us-ascii?Q?SOL0lfMxxFoyGXOcrWoHZ5f3Q63YlnvEL8k7WXl5Cx3UMzLp7qVdC4h+ZCWt?=
 =?us-ascii?Q?nq5ubJK5S/r6pMETgP+4nE/LlMcPGzh9ap1EGpY8KOuJK86GNuUy+1koLVG8?=
 =?us-ascii?Q?FF+L6pz8ND3QM5jas1yQ3Alt0wIME1RYkO957/KdLugs1EASWmxKg3frfXQQ?=
 =?us-ascii?Q?tMPYQEaE55ZxdrIrqpdaWwKeRt9+YT+cv8u18++xT8Iiz+o1LL2aATA50jpZ?=
 =?us-ascii?Q?ZIGTlFiJllmikSVFj7N1ICIW4NBWI/72FHY2TLn9AwZA2OL9xzQaInZJz1ZB?=
 =?us-ascii?Q?UyRYI9AClyjdL4hFlFFD/AcAhW/rpSnZ1tcRSTsFyX0pWeG2T2B5BVdCp1tf?=
 =?us-ascii?Q?H8DA0aECY319r54hNWaDR4oVeWfTMjRV8h04NaeaCsK5s769Nxqv4JD/u4o2?=
 =?us-ascii?Q?iFigqvJluVRVK1xg83rmV+11MbkaFdK+AGwtYsvOphO0USiUvHljFpienSTw?=
 =?us-ascii?Q?twl76nKbIiGgKvHixfTejlGUFgkh0hHZTL7ahKBLr/Q5OR3Q3QcskxDsYwCO?=
 =?us-ascii?Q?afB8hXUWUKmZLyUk5yF9I61eCehq3R/ZH8zc7YjFzvuOzkEXvFGwseidZ5P6?=
 =?us-ascii?Q?UuuSwSUcu+bBqohox7YejBbJV4dwo3rAHJjpYtFMg18uzh0DsFNZ47O+NxRY?=
 =?us-ascii?Q?iKtaSEuGro4CqMyWwODGgss9gQQMWZysEupLEji7w/ZsObjH4TvR2T7snXRR?=
 =?us-ascii?Q?ILZGCfnUY8i8oflodPzq0q/w5tQBQ2a4zCh0+TvLAc0wa/fkOMg4dGPpgya4?=
 =?us-ascii?Q?cCAP6m3PKlmbnQrWL5rcZWTZ0eGFQpbMvhTL2peQEDHo0ElNt8/IRX8b11yK?=
 =?us-ascii?Q?spyFd1zjf6fn37km4TBVgxUZjl+oK+7nyfB15QNceEIEY6wrMIetXLTjpyYe?=
 =?us-ascii?Q?w6MeBp9blYNtG9jiROHzj8B/R25BY19GPOSkj2D961zCIgv7UDfLsRDwmYjU?=
 =?us-ascii?Q?S2VtHPl1UDOWqfQOsKUaW9i32DBDRZjYdumyDO1n5LAq9z85TKttEzCb8Pdo?=
 =?us-ascii?Q?Q8mN7VZxIVo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DeCPhlCwqM4SaCo6fO6jhcF1RjaWv3OZOZl4XjF+RNHCwCIrNhFI7WG+SphD?=
 =?us-ascii?Q?4Mi0OU+WG3uDJqsB0Mif2vMS/uIk1L8i2wR0rJiQq+oZPx0voeuSlrsncPjb?=
 =?us-ascii?Q?Z5EyOUaoxN94t0Ac9hHZZZV6zW+OOJp7Oupa9KXv1WFdzEwx8vh4mpSE9wOG?=
 =?us-ascii?Q?1dpc32spHorgztve/xJ0mp5AQ9GTa+LHOvML4Fr6KxA6F/dPlbv+OhDFp76S?=
 =?us-ascii?Q?GQs/ElnfEQHiIaNTKsabLPfe8rfBHaTq1MfDuZcQfft964jHQLcuz0eDmBSd?=
 =?us-ascii?Q?k35Z8rcv7+5WtnNZoXqtnzC7EvRhu+3w3tCWB2Sc7hBy1MckZ+XB801NbQ+k?=
 =?us-ascii?Q?rAbb2/Vr+F3OciQBNf5dbB+Lfk1bmKiU1sA20cNCe0PBzf8Y0S4Ul6lCWLGb?=
 =?us-ascii?Q?jfwrnRc7pQrYoxGCArYS/Sr0OD8rgOsVsd2mDitndEY0hUOLKu4xtPEDbedA?=
 =?us-ascii?Q?nlA5VSpTxrzvhgbAeYz6dAT2Zy3c31za1i2qayIdWDANnQR8kf0CbqEh1EfV?=
 =?us-ascii?Q?pGGnrmY7xcbVqDVe1nQ+X6u9W7+2GbSU2//gmFeiqkgQmLlmgVYTuMD5CER7?=
 =?us-ascii?Q?+6R+oqVmLTNIVjz59mFCh645qgEgDhrYpFrhe9VkZNnNvksK6xd0oX4yuLQW?=
 =?us-ascii?Q?kBOHk8zyHRxo39YF9jITy3iYXMJXuNDXKhf10IXiqrEf+mtBYsxlMeQqpxcm?=
 =?us-ascii?Q?uVud0Lvnkz4KuvwpI5aWjzly8Qc95y7UeJJ3K/D4FbAuB37SJrHCcpINKb9j?=
 =?us-ascii?Q?yKSEoMjNzd33k2y1hRJuAQ4VxqT1TEaLBqdq7VLzcqCqwi/PegA2HUb0Wjbn?=
 =?us-ascii?Q?sVQzYW7JyZZYWfwpkoA8zBpSvha0Tt5EjWMJmHA06r0k2DGlgBfFIHfw1Yoe?=
 =?us-ascii?Q?T4wp2aKQh+Gzg+VP2aVmMhO6MdIPJtOE3zhgEvZRTUFLhkPwckvIG1CvyX43?=
 =?us-ascii?Q?0bDyXMKWa2idZLN5BnkolV1VPokOobYO2bzvlcMH1meAy5l9qTqPL7DX4v7j?=
 =?us-ascii?Q?LpBu7KVCFNVgQ03UZtsXEW765mUg9m2CGn3Yvp7zemUAx8achHipVcMv4hLi?=
 =?us-ascii?Q?EJL8vfE54wbvsHrC3W7TZi5rdkmifIcuupFPO/DaswBta3qGLN4LmDK8nqu6?=
 =?us-ascii?Q?3/SEvWIhszgDgY65nzVViT0cRPB+SU8X+X9/S4r1WQrgmKz6+rFE3SY5fs6/?=
 =?us-ascii?Q?SEdBXkZ1YO18UfxDTlxGq5kVR7qYC/74qy0r+jUlbkJydixKKvBh/TvM7+iv?=
 =?us-ascii?Q?/nt1V0U+O3FBw626jdtqdiIg/9mVz8YQp/6a5Ha0sqbVkW2SbJasYFwORMGE?=
 =?us-ascii?Q?QzhVqb+amNtpa3yd/6gY/yQQy0xwHHgbnXWHjQIrY/WEFhJbsMVe6a1IxP3t?=
 =?us-ascii?Q?E7EiCOm90jOnNoBROQgm/FhxIapEmnYrqCBRdCdtjYew5vSrGu2VVF0RjMCJ?=
 =?us-ascii?Q?dErY1l1Ep3Fg72iQFbPnAwnfLv4Y7nUobPF50rxZKD/dV7ZGxtK1+g/Fi4NB?=
 =?us-ascii?Q?cfwAeSbCjXzOgu09PSYQSZGL0frCAAwWiEywW47v5abn9xLYKvOREcv4NfjA?=
 =?us-ascii?Q?TAUfM6/VeXpFFDxnhaG3OAh0hWXduB5lHnnfKvmTHZ6VWIN5MneQcjb1XKYe?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d20ebe6-9f15-4bdb-0622-08dde111cd8d
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 00:21:13.7374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DQmmBihQsF3WF9OiJJ29xgeYacEJ0nHrAUQwPTWZDnNn3kAcu4MiSzz1hN//ruXeUHsFrAJllnirpzFHitrr9MO/Gazk//Z1evUDHR4T+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6138
X-OriginatorOrg: intel.com

Marc - There is something off with the patchset format.
The cover letter is usually Patch 0, so this would look like
like:

[ndctl PATCH 0/3] test/common: stop relying on bash $SECONDS in check_dmesg()
[ndctl PATCH 1/3] test/common: add missing quotes
[ndctl PATCH 2/3] test/common: move err() function at the top
[ndctl PATCH 3/3] test/common: stop relying on bash $SECONDS in check_dmesg()

The cover letter commit message should be general, not same as one of
it's child patches. This ship has sailed, but for next time take a
closer look at what your patch sending tool is generating.


On Thu, Jul 24, 2025 at 10:00:43PM +0000, marc.herbert@linux.intel.com wrote:
> As requested, this is the broken-down, first part of
>   https://lore.kernel.org/linux-cxl/20250611235256.3866724-1-marc.herbert@linux.intel.com/
>   test: fail on unexpected kernel error & warning, not just "Call Trace"
> 
> I will resubmit the rest after the review of this first part is
> completed. The different parts are logically separate (different
> "features") but they are interleaved in the same function and I don't
> really have the time to fix one git conflict per review comment. 
> 
> While it is a requirement to catch warnings and errors later, the
> better accuracy provided by this first part is useful alone. If you
> are interested in what's next, just look at the bigger patch above.
> You don't have to!
> 
