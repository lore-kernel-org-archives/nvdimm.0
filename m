Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792793594;
	b=Ol1h4XyX9BX0EpqgBhKUdztrIabgThpEAMKZbRHjnK1y6zjQWQfhge7cGrbBtoFLN5Zv
	 UcXHwKX84Eg+KQxJT/POaMD1b+E8Q3A7RHjL4YZM0WN7S9J6aVOJ51ikZILsXo0ehpGd9
	 R81AA5gJG3wtZWgtvq5LSjgcibyDnj+ZY7W6RqSKhtDTsaMtf61vTNUqpFv0pwHTdKuoU
	 iwNHwKqiShxjO1TfvCKm7uJkxpz/9mVAXm16r/NkBh8cW4v7dZ3HiDbuvPS98cFIQJNBw
	 +meUS9kntWN5aGVRzEL77TrNpcYwNKNxrdYpBjaYqdzcH7ABKwqGMZvkLfaCCaFC6Pg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792793594;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=v4bSrRSm16Lp4VPAV5ltVMsaPdpJlD6s8bbWSdbcsr8=;
	b=0ahPu/osqNNhmR9w5l/PXzkgTfU2z0CbjGv02yuznzvd3gtW4JqUCORpJyATurCY3yVa
	 tfNwKQrp9Is3rwW4Iv0pyiDaoBzubAJp4vYK9XZq/4hwc3Xswc+Fn2XSw1EfpfAe8CRbF
	 R7Gluvh7QQwgv0gczzvhGCCygCKPbILs0ff1rMChjRhW+HjNO94eizs/n5dHU/6uSnn7A
	 PVRepAfN2+Uz5XOPMuj6tG3TNTqwoswGOgq0jqmFkfubdP5IkqQog978kqIw6L9j2xPqm
	 ok0m6c5BCRcpMyaSb1j2pvH8rHm9mVqor403U/Tt5O4ySIKOaYxct8vIGZQTSXFob7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VRg4rVzC;
	arc=fail smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BAA606A31B
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 22:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5BAA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VRg4rVzC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792793589; x=1824329589;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YbFVKihCY6FLj4az9gDqzcILAb+qsVRxGveemJjdlbM=;
  b=VRg4rVzCUNl4/EwrjsihJf2+EJe5kYyq+49HBIXCyOdCxnRD4JMQGY0k
   YyaWS9cDQp6Zd2z4JjN6SmQ+ffWeP9NkVo1mqautVTpSEXpvvhMt+O36U
   /fi2gVGlrjU2RVxCRs5OjjTM1IcvHTHyxDc60DlpJ0ivWwheJyKtf5rmP
   iMAroyyv7jUiAgOT8laS7ELQ52xWfcHtV7O3nG6gMjaO3tXuLlryrjgy2
   Rbr0Lv6iT5OpDTwucC/MGO7RzQZOHmrLVW9IcshUOexHXHzNaP2ZQKlXG
   IfDPwRKnIK6Wh6IKL5bdgJkqgE0TOGSOWK3R/9jSq5U3nfpDe7JzevlYe
   Q==;
X-CSE-ConnectionGUID: B5tiTTDhTWqV3xd1Hk9SyA==
X-CSE-MsgGUID: e7rej+sXTrKA8z1+Hy88xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1561813"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1561813"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 15:13:08 -0700
X-CSE-ConnectionGUID: o5m/bjKuSPSvRteR8+ejTA==
X-CSE-MsgGUID: 65zWzoPpQoesA2mkEvVQOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3760635"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 15:13:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 15:13:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 15:13:07 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 15:13:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPXubRunaYZTuJTASv/uN+19cfffXUhytv6ug/03e+RF4qSg/zZA1C5RrwY9l3lrAVSPEdZSMhxhdc2zVhOaroJP2wZGmFQMRXHu1QOz2yEco8EM4yacfnkrXHg4rk8fkTLk7vLHwWzKOstTPfNSBKvBFyw+0Yl8efDJ4u49xw5dVabmJVzL2bU0HCEmUAuScz6CWtR7yVJMwihhT6HuQoJenyaL6jr5Q0srSOX9COx3oeMdVRr6HzPJO5HqGqyzcWLWt861suqbG6AGDazJTpGPEm9ssJwuBhzprFwlIeiovyhwezlgvxv9L0YNkXMpJws3Y/Xc2JaZRlda8aO7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4bSrRSm16Lp4VPAV5ltVMsaPdpJlD6s8bbWSdbcsr8=;
 b=c+EnIg4+W+BeJRZYmooxg92QKORqqQnz63lAP6vHWe/v8kw0J+kH7kW5mjZP2dL5GBNG40BFBHyHuBR4fTVewSIjAPUDg2GuWA8xCpfgfGKqTIWlwHljMP8Fh2sbE6ZuOwxRfx7SIXd6G44cdTdWHVkA4gcbGMBlPL96ZI/U4eha7XTEsPomMhgQ6aRxShVwNbHtYYqXtM1ZgXqG2bbBKi/EvB+epqzmiQdD7XX94hi0t80d9ncvmHdX13cDqbun7+1oTpoPdCKSXEIvChJ7Rtuhx9uCZ6gAllcfd1ibUGOJMHzXpPMtm7gByynXi67wO1M7gdYEa+FlQZHxJcrYxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB7616.namprd11.prod.outlook.com (2603:10b6:510:26d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 22:13:02 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 22:13:02 +0000
Date: Fri, 23 Oct 2026 15:12:59 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] cxl/list: handle missing debugfs when reporting
 protocol injection
Message-ID: <atvb60hJotejiLNG@aschofie-mobl2.lan>
References: <20261023011333.522080-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261023011333.522080-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:303:86::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB7616:EE_
X-MS-Office365-Filtering-Correlation-Id: e04eb722-2cd4-4d39-48eb-08df3152cdf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|261009223027099003|11063799006|56012099006|261022105027099003|261021121427099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info: vBKctNaV58jb8WLD5L2WVm7WciOyh39l/AhLVUsr6Q8F7RepI6H1foyqn99jIXXYGYhgBopqtVMOv90nGZ8zbZytI7abjpKRRtGX1X/daEJSI8Hw/nKOmfaKMECAzsE4Bj6wCS4gGIFMseSJ5FbCIi2M31R6AQHKjXn9ZKl2Fx4jgXtAClX8CrnJZ2AEFpw6HzrK5+QafcchB5VWfXuwquqKdKEQKz6A9BJpiupQow8c7mYLx4MW4lJbHSJ4aNQw8k6NoPNz12d+KqeBiL8cppC4LS2m+vOvjWbu2ipUtm3Mdmf428q1lGcKXPCXpso9ytgXeNJvGMvspMxWuafV6FA1M8ttIZai+lTmi5lUC/Fjvl71IMeLc2P39Odbr/XYYGscFqmW5KVg3ZSrnIrDD7gyLGBKtW796xK/mUuOk5bL4lqVe8r9AsX9t7pQGe0PSGZWEW2zWIDvmNp6BSifNG2hvk/tQ2p/07kOTx87lOihUzL0hD/uEf/GdWIxMuU0Tw8hymFJ0TnrEInF4aQst5cqa6F1knDmZQleV/r+0ZmsFaMfy/FRM0qQinB3fLDWoqRhnRhcZR0af+pMSLGsAwogrODQzcfvm9d/YMUhT+EmNPZUCrXEWpv2FOq1HMKR1swA4jDRgWySF1lojzSU01x8Z/fpig8+0smKXlz+1Yk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(261009223027099003)(11063799006)(56012099006)(261022105027099003)(261021121427099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J/sCbZ4odyfmulZBFltBa1ACtzAgmItDo5uAas3o4HaB3Y2iYqPMI1TfNTQf?=
 =?us-ascii?Q?Cs3DHh/SF3h0m9k6AIoskmUiVOb1oc5/0D4OPxy600Ed88WIYsN+ZhwgyGd5?=
 =?us-ascii?Q?CyLQHObKkuGdeo/+JE7mdcs8VJHKVmnNoLLdEmHa/Sr8JJ5fBy6aSRGAmzkw?=
 =?us-ascii?Q?kIQsTEmdL0xc1VoU1hmCcaSc8yX0uJiE9HKMjD+eaopHjh2U3GAXCGVem/a2?=
 =?us-ascii?Q?6/SbLVpt746D3mNXrrfEcAh+7EL6sxJfjNsOzsNj3WQHEk6kfSgkOybyBVVr?=
 =?us-ascii?Q?/okY4+a73iTq3sPf0yZb0OZNi2zFbyJacmLiHk90UciLKUTnpx4V0PDUTaJd?=
 =?us-ascii?Q?OCEQ2NeucnR27aXm9hvMd6jylQsllDSUvyI2Iod19Ll7eUp2m7hVtAUvbcMw?=
 =?us-ascii?Q?TqevIsYgI0MM2TrVBH76M0CHcseTHzSn5KtrHBpn6tuYi/g9CIhuk/O2r9h/?=
 =?us-ascii?Q?m4fJUNrcH4L9Pslm8QW3BVcZwgpy83RVKurHetwy98R883+AZBHiY/GZBL4y?=
 =?us-ascii?Q?w6LTVU2itjVC3q1hqfOG9bENCjaOsVAL1dtWmODpSawJe0XK7P8V3DMQ6RBq?=
 =?us-ascii?Q?AtK3Zzpah+8OLBxP0N+vC5qIOstdsYJQyAJ5tNRs1CM8PNnG/QdQ6N5rI233?=
 =?us-ascii?Q?hudD3iNfpM6HHMM3hpHRJCJoYCQFbp0hfeRIEr8ALSUnz9eeWcZHvA9bSe+z?=
 =?us-ascii?Q?ZeLOmEvy75czb7+3+vs2C4pirg7u5n/O+NKZspMzXRHAfOxw6lZY/Ik12kU2?=
 =?us-ascii?Q?jJSzj/GC6//Vgj35lSQRSIh+HA31CkelNzFVYxD5RhI50MmbeCZI+SaVWBTt?=
 =?us-ascii?Q?soW01lyU9ooM49BjijZfkoszymWUTZ53+COj/O+bJcMQUwPEpBORjOuQ/xiv?=
 =?us-ascii?Q?ylbf4adCicsr9Y2OWunyvq6RHtomV2Y6OorqWpl93hwM982GPmaBQ9rkbcBx?=
 =?us-ascii?Q?SU6t2KPiExL5suGJJ3I47gPNj/OV4b4T9fnvwC677EVOdcyyM1n3xoPuk734?=
 =?us-ascii?Q?Sd2YU5mN6hzAK1n4LtZHRY/DIKlTkEJ9bNTSrBh7vQFUyzKRYmhtdaGOzhKd?=
 =?us-ascii?Q?BTFtP0WXKM0ix/ES32Pp9gF0T4twFnroxAlw/gGncykUpGk6Fe2PqAC5C/km?=
 =?us-ascii?Q?UNQqhhDGslpi5tUAfh2g1Ud01iplbY/vyarKUWNkDx28RaT+455JNz46q6hW?=
 =?us-ascii?Q?fu74q6EEcM2U6ziHB5smYoTsBMfblkMRmZjgp0RayPjg0CofpSryPUkKZWe/?=
 =?us-ascii?Q?cVEGODUE1wOB+TvHfmRnTzt7b6y1Yqqpf18hhZpogdz9BLnUZnjiiuDi6Pcb?=
 =?us-ascii?Q?QgZ19uL5TaCNMwuU5J5oc6VKC1vqnVlj01g8kmtX7vVfhwKEXMqJIO6DjOKN?=
 =?us-ascii?Q?pGxW5LfWM8soKC3VYA4sw6WRy4ni5/a3P+kW1/kYq3tDiwbY7qSkmnY82O9Y?=
 =?us-ascii?Q?xvdIemcVtVZVN3sG139aU6NTVZg/s1wdIoPwUDzW8Ul2/KVicX8/pfxuwpu1?=
 =?us-ascii?Q?PUXP7Uel8USEyNAYpSM3kmhkUEvOtlwj9OB1u6TpaStUBIDIOW0q0BVmP4R8?=
 =?us-ascii?Q?GhYPW3o1X84mVaa+iwd+cKGVfBZmsTyaYCfsx7juyVSKgXI1WuEO/i7FgD4r?=
 =?us-ascii?Q?fqLLVPMqQcpXu0vjlaSkXfUrXoKJa5H7jpO4shA5/W1RIfUDcDNsBWlBweET?=
 =?us-ascii?Q?XrXUGHRuYf+zpSzpZkRgoygoqWlEkCr/mCoek9PAzN+bhat74i0fGXqMIgHV?=
 =?us-ascii?Q?x841RDUAXAs+LzkP0W1x/MkySzt+O1Y=3D?=
X-Exchange-RoutingPolicyChecked: 5CGR/Zz+6eBcKEHlioMg0EeHpq16RrTd6xd0a+yJFFVVI2mRO9yHh+TQ2rDoxDgfBY271RH50k+Um00bk+mU/rdg9DrdiLug+1er4O+1beE0bbQ23gFI4YMD+gOWBHPwXC8lrRJMlIfpiAphkX5XuYNa/eVcV5O4WRjtG3uW4mrOAfX3v906BY7EiJw959Y82S1OXH28mM/whyI/ztApbmHSEIH7YQeskPgxiEjKGMHIanSLo36ssucrIXnaj1ZyP75AHO9psRPvKHiMqDSqbP9JfpqfbfUvq8Il6rk8D9903KwxY/Zsk92hx1Dls+aW62McwOTsOh2tMg/9LfmBoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e04eb722-2cd4-4d39-48eb-08df3152cdf4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 22:13:02.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPGF5phZncFHLNLzzLOQrWQDJprydojtWD1ZNUL2I3udWZcMw/GASPTJlOTbKO131wmH2X1V0mWUab6FDiTFYxOG8z9PG88Qf5Bg+RDbuVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7616
X-OriginatorOrg: intel.com

On Thu, Oct 22, 2026 at 06:13:32PM -0700, Alison Schofield wrote:
> When debugfs is not mounted or CONFIG_DEBUG_FS is disabled, 'cxl list -v'
> crashes while generating the protocol_injectable attribute for downstream
> ports.
> 
> The crash occurs because cxl_dport_get_einj_path() passes a NULL debugfs
> path to strlen().
> 
> Return NULL from cxl_dport_get_einj_path() when debugfs is unavailable,
> and omit protocol_injectable from the JSON output, consistent with other
> debugfs-dependent attributes. Update the documentation to match.
> 
> Thanks to Christopher Kim who reported and provided the fixup.
> 
> Originally-by: Christopher Kim
> Fixes: 5d596866f8c5 ("cxl/list: add injectable errors in output")
> Closes: https://github.com/pmem/ndctl/issues/300
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commit/1b126bf930c5
