Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD55198A3F
	for <nvdimm@lists.linux.dev>; Thu,  6 Jun 2024 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717692576; cv=fail; b=A401k/CMz/jdM9YZKntAHqD43KGmV2WVNqw86NGxD+5irc0ViLWyj8eO9GV+CI3g/6AnVMa/Ye/d2wygwq2J3BsfqPHVeeBdbCxLnJYk0TZE5wd7F4KlfhjlFLDXB/vfKYGHnr/+zP3FmHtxxNvLlkXWYojJTMCAu/VDT0d3ZIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717692576; c=relaxed/simple;
	bh=pG4jrkflHN5PSnG5w/dqhZI8x7RjRVjw9JvF42pyKDs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fChmClEo97/+zdMMPQOlj7uQTTzaowXGbem75J4zzfzHbIDDdbTi3LSS+oeWaaRfJq0ulX8JSbJV9D2htZNrx9k+aSWXRnENxWHd6VjeuL8bfe/jmTvszz0MDNOuFOxtMEaoR3lan1mFqY8Ou2pWcQ2+PMqogrFs0IKT++ifW1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cqR/sAsb; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cqR/sAsb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717692575; x=1749228575;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pG4jrkflHN5PSnG5w/dqhZI8x7RjRVjw9JvF42pyKDs=;
  b=cqR/sAsb4uaZcK/Z+e/amfuKwsF8AL4xV+dE5B/CV83T93ddcaEJOj9P
   PccvvtAhq1abV5n57dIX4fXKduQWDq3qEsxhIomV64tZeaTMPGIMqbsAG
   pRKqbCYAeYzuE1imEk+3+vrWyFZF8oWAjS8XLcQ+7PuGnrSYQCoYyVL1i
   sl1748/fm4lViJoqSvQCUiPw/Sy7elc93Aa9kgDFBsSjidHCpXv/CiT/j
   DPaY1vNeHkz/3zLJnl8G1Ensd9l8qGb9/nzO8qzPAJGLRidIWmk2vp7V8
   fdfM54CKlmbao0MlmT92zJFU7tFIrsbyBA7dmz+UuvLmV3vWGvlu1vdlz
   w==;
X-CSE-ConnectionGUID: yn23+eXfRb6T0lccsJK+7g==
X-CSE-MsgGUID: HT7pGX6aSLWrTgp4bRWXGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="31923577"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="31923577"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:49:35 -0700
X-CSE-ConnectionGUID: X8csKomVQs+jVm5RGXgo2g==
X-CSE-MsgGUID: bQbOTc60TWqcks0oJzEIXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="43120117"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 09:49:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:49:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:49:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 09:49:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 09:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oiuln+XeQwZBmFNr9mqfMaPDMAXLeAunU96qMLqzdE8GaSB4Fz7X0zVvlYhWzgej6qGgqqaWkEjZBQjkWu5RXWi+jiNMXqTe+Ff393RyFc8PLY/UXCgmboDSBdiQt/BAmKVDM7//cs6LFdfsQBnkSgm5jFM/GpnY34ww6Ra6l5MxOxfXaUfm+l7+pIVGLtlQhlk7w5cUDEFBU/Gfv8qEdDXGHE27It48JMBx0rEbS/n+ulr/0am+sChuMIuJLSzXrrCvhc4bKDfTS/ymjzGp0VOsynfwNYKDOuzp5jeqiXgrLig1QZf2d6fCthuuMp2iIuziIy5xtvYL6EFdILPVCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYTPBaQ5Vlq957sj+QVaKk3Vvcd0SKV+qO87gR+E92k=;
 b=OzYwA4PBPlxrZpAxV/m6cGXNwZo6jqa9cLYwCtRfwUXILiE86xJyDGURIFq2YyLe9Jj26yRshGT+5L9K2ceFrg4yyzZROkogr2KS2cj+eOPlNVBL4Equ1/UuH1rkKSqezPxSYgGzlztM/2XcvKUhncT4ik/yIqJDwzuKgkqB8/VSJhD8EJaXkGsvEJI1zlerIH7XJICZq0YzKqDc5Z6Js0pr5UVPzeydpWXjykUuHH1octYvXz4ifyFFame/JVhqNwEtDv7bAfnH8xmpaUB/C2kQX1wnhTFyiEgJbffXSV+mTK+P3iB8wyJ3Ox0PYq1DSrOO0Ylrhjm26pMaHIADKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MN0PR11MB6205.namprd11.prod.outlook.com (2603:10b6:208:3c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Thu, 6 Jun
 2024 16:49:32 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%5]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 16:49:32 +0000
Date: Thu, 6 Jun 2024 11:49:27 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH] nvdimm: Fix devs leaks in scan_labels()
Message-ID: <6661e897cfd4c_16ff40294f@iweiny-mobl.notmuch>
References: <20240604031658.951493-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240604031658.951493-1-lizhijian@fujitsu.com>
X-ClientProxiedBy: SJ0PR05CA0062.namprd05.prod.outlook.com
 (2603:10b6:a03:332::7) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MN0PR11MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: df047e8b-01b6-4f95-256c-08dc8648a371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sJhT0gyh3kQ8qcWhCeTSRfQLQK8E1i2HlvBUtS9qNuqPjONy2SglMQOlQTow?=
 =?us-ascii?Q?6Zt5Ajl35bM6YOzdG1JyJyT6pO7k9RIf4yVbyK/Vs+hdCIaYNRVufStKX018?=
 =?us-ascii?Q?Z0wf2w3Bfs5U7hE1K787ODKkeT+dIzfraKptTT9ZCf6mUeAFloOpfAJSVadT?=
 =?us-ascii?Q?Vi9tdcJwGSxkrKcuKHsSbJsA0jSTMdSkhuGNq72+PjuYZJU/EcVqRqgbPSV3?=
 =?us-ascii?Q?OUesMuUQP3/wCDnlfxTWpt8bQXnYi01v+UciA3l4zujLq6fU9W8YD7bUjuvU?=
 =?us-ascii?Q?D1X2TkOfIWSD525RgYKc/xuSOjby51cA2fCQEa5avCYs8gHkl5c55LjR/poU?=
 =?us-ascii?Q?UuZtC0Z6L4Iom65LFj2McXsEk32AAXghHZ/F2CjCqUGiaucN/zOsDPWPD5Vi?=
 =?us-ascii?Q?mGqK5fQkaTstbGfFbLJTw2UY2jJ08jO8apUGTtLxKR39Lf3H+xEs02VN2GYU?=
 =?us-ascii?Q?QPwAFCDb72p4VJQokv/MrevCPp4sVVYPjYiN4K1txqLXbaQSuCd5jJq4EZ8/?=
 =?us-ascii?Q?aK7HH5BGz6SJkFlh6YDukFMye3KZK+bH2jFYqVOueIdLFNdZPV52TClne5rD?=
 =?us-ascii?Q?p6ApdDUWbzLnLVr0t5O5WMTHt+0yyLsgAqS3p5jwXhMVorEB866KMmjZNzcD?=
 =?us-ascii?Q?vQ0BXEHMLSDD2ZTlAzm2/97r6lLBy5LV9cE3N9TwEXsc0VetV10ThIUulqFn?=
 =?us-ascii?Q?MZBI2qtNOvUQI0CjizTTnDPdKwkjBMC8Z4V3z/OuNgOteC7hE3B8wFT2hpmA?=
 =?us-ascii?Q?E5z9k6pizZ+MugQpOPZAFK+9+70Fhfq/L7l6eTYf8W/fVqSOM2005EuiDpUg?=
 =?us-ascii?Q?KafUHmy3HaEeG64lLVNrlmKJhsRH6G0PlZyUziZwBgtv1QI6LsBWbG2xtSWX?=
 =?us-ascii?Q?bugRmL4cpV8mxSX89DlFgoKduXHBAcB+1THjbPKCa53g/BH4QKn/y/dDEEgQ?=
 =?us-ascii?Q?Wm/VlHvmM3Urdf1AsUhDoCC5F0LHiK84utLFbk2grzTMkzDuJ0jKJAMLTJPi?=
 =?us-ascii?Q?Jx3ADivQ+uy/4hFM+xYu2tV3Em/hNSNaDMJ3CTjb6OREmderUbi8juQ0uYL+?=
 =?us-ascii?Q?LcNs2L56t4/DgVhM1C87SC/OyK9NKg9heyT71BqNQQdlIVRgEtk+5ykhUJTz?=
 =?us-ascii?Q?AZzmCq0dai/NkierGANIaCEDI8tKbKnwLWNIWz+5wBTw6KbuCJkeaJ66cGgT?=
 =?us-ascii?Q?WVOgz5eoorhpVDYixPyIqUSgff0rvhEqaTSP7mBNoM2Li87gqhWGg4SNndNb?=
 =?us-ascii?Q?7sQsSBOvVIAM7drzlWLfIztrlRRgVqaPlU/fdUGDyRbC+9RKkHyTRWKjjMXq?=
 =?us-ascii?Q?S3o4z4IB0pG+m5sC7cwJ9ZBc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86/q4c7guSnuRSIFYn5WA+fNYkUzLYmEOP05102MndRI7DEos9sCvGaE1KNr?=
 =?us-ascii?Q?w52KfewCyXfcYSQs12c9sCPbh3glKfDlem+q6m49DR48tin2o0oLmafVNmas?=
 =?us-ascii?Q?odivTohI6nALIlwu6s49xVDZ0tuL9LBiEt+9vGUUju8VQkgXeeaNOtxCixH/?=
 =?us-ascii?Q?psUpd+N/T6g0eUnZNaSElfVkOOH1mnCZNlKSlpkfPwbfDmanMa2FklSbJ+tB?=
 =?us-ascii?Q?MLPr9KB2K4faOz526PzVmUbwUCscP4pGgkReQIdRQm/Ga8mtxIZe8rg/rLJF?=
 =?us-ascii?Q?eREJeP6FV6gsXIZuxF82xhu6UTSDkJmX4jTdD+ruejvF0y9DngcFXyuyoI9x?=
 =?us-ascii?Q?++e6es4oCbiEicrgSidelyNnktsRZbEz6ZH/z7iDQTn24KSpDKbESBU+3cey?=
 =?us-ascii?Q?RGqamHZuwyqlAwFo2CbTC5Rh+UMfNpuUpPnBC3syzWvQCvAQJpKcnu0zWfkr?=
 =?us-ascii?Q?lF8YnnN6jiDWKydNtK9XnxhMQrfn3JvgAtDX9gceIAmYJ73IyleLKWf/kQj2?=
 =?us-ascii?Q?z2OgQj71lOUTGG5GR1p6AWAu7t5GRGl0hT3v11RmCYoa62woQEIOQ6UEjo1w?=
 =?us-ascii?Q?5hCgUIymbD0Dgg4Xi4zEz8zZOMRVWbVUg6wSvubgUH3tQMHZHfLtZ0ay3vh6?=
 =?us-ascii?Q?fp0ZHeKRNXVCpsshVVsd8Gr2aXkELCnf+35VsFro9q2YEVb2ajj/XZtWLcyr?=
 =?us-ascii?Q?d0TMVhhlErX7WH1tsCUzQu7i47h+D3CcB9DFw4UV+1MlZmfoxrkfPDeZNa+X?=
 =?us-ascii?Q?SJZmGdcOwrl+/lEJm4+f8CpgP99BZR6FDdr+vr4IE6RD31AgJDx1GbDJ5/Wk?=
 =?us-ascii?Q?YKWQnxXHc4Ws/jnO0XgV8Pt8QPZBO5tqM+zjxrGxO1QTpPnLDch+HL7ezB5i?=
 =?us-ascii?Q?qpxyUxrGFCYxAXzZKkhFXpbC2Y91V7GQG1arcWjv32loBUgT1mkThEqxMeJA?=
 =?us-ascii?Q?Owp4VWVb5d1epsnAVK+TNBzUO45GrRhnalQVMRbL/nV5th2OnSli3f4mFsYH?=
 =?us-ascii?Q?Dd8rQhhMGsGpHHxRrk1ZsK/dVKoKpVfGE8Yy2LmJCzfcpJUfEtr16baF+k3T?=
 =?us-ascii?Q?kWV/8kCyp9T4e6UwdQjj8hsgunfX+dEpn3xuQ5lVb2N98XlZwJRXkqxvIy2E?=
 =?us-ascii?Q?A2e2PXc1yqUAiRXDN1TDRixo6hLJF5WdYb2ZItQQV0YC/HHCGzjXC+bvHc8d?=
 =?us-ascii?Q?tplHnihs5II+Hl0FKpKdVP8jjq6jKI6RNBkpwbO8zj2IgXifs07BGX/3mng1?=
 =?us-ascii?Q?/SJOPLE7tYOC6sS7fRwwx/KfDTqiyJXv5YpO0QL6mtTtIZLuwWr+EwQDrGn/?=
 =?us-ascii?Q?mVcnzDgWbH7scwnfbYVGxKnDthSrppVqkJJk2AY26EZyVdew9PlaM/G10lgo?=
 =?us-ascii?Q?K5DY/LCQ6hte7HWIwNI38dxgjzypoW7m2Ew58GRhwe8RBT7VQRJq3uHtILk+?=
 =?us-ascii?Q?szPt4vGoX0amNZHGMAcZqEi83ZkLp0ZDM3E67sR+u5y5hTcv1FQIsq6ikzmx?=
 =?us-ascii?Q?9yULNjbbv9gm/E64pCnK8SFzMVLxnP2ifEja/mKWyY+N7/z23B9+lb7+arZM?=
 =?us-ascii?Q?j++/0PlJzulZh+vHPyr9QkUDHlWIv3/5rVm0ESkp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df047e8b-01b6-4f95-256c-08dc8648a371
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 16:49:31.9467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPTYitgTprMt9rJj7Ttvxt4IeCS4QNPl0ERVySMaUiDsdZxU94wfIewpb6EfgF8jnNmxlGPeLT4P1PbeLHywpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6205
X-OriginatorOrg: intel.com

Li Zhijian wrote:
> Don't allocate devs again when it's valid pointer which has pionted to
> the memory allocated above with size (count + 2 * sizeof(dev)).
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
> Fixes: 1b40e09a1232 ("libnvdimm: blk labels and namespace instantiation")
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index d6d558f94d6b..56b016dbe307 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1994,7 +1994,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  		/* Publish a zero-sized namespace for userspace to configure. */
>  		nd_mapping_free_labels(nd_mapping);
>  
> -		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
> +		/* devs probably has been allocated */

I don't think this is where the bug is.  The loop above is processing the
known labels and should exit with a count > 0 if devs is not NULL.

From what I can tell create_namespace_pmem() must be returning EAGAIN
which leaves devs allocated but fails to increment count.  Thus there are
no valid labels but devs was not free'ed.

Can you trace the error you are seeing a bit more to see if this is the
case?  

Thanks,
Ira

> +		if (!devs)
> +			devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
>  		if (!devs)
>  			goto err;
>  
> -- 
> 2.29.2
> 


