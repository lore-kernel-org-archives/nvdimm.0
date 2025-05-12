Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73AB25485B
	for <nvdimm@lists.linux.dev>; Mon, 12 May 2025 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747074935; cv=fail; b=DvfCPxhFysTVHrviCuDhMwJGn7C+9OMZhZARq9FLdsKSUD8NXeCg4DV7zt1WtX2pvpnMEWbIzKgv09nd88UtSwXJ14kPe5txWri6k1lBMLJFxVMVK4m21AbV3ZelloYqG6W32Rq2kyYhAATwnP7+1cWsM/0bl+A+V88KHq9FDJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747074935; c=relaxed/simple;
	bh=xz1ICm75cOuzXF4hxmDyrPZtEk65/qK//XtPWgEHyRI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cehE2PUhWiG+yuB+WQbQUpkx0LKa75LsLXZOv3yeiG3sZ0ROEYcfAimb5uLpUxy8ffp3w8+mgN5VYVzpizoEoYJpgS5loSSC0oI9Ls0YORAmE7r6185rssJUGEJVr0GaiWodWSW5SG29Gn4fc3lYX/YOnRq/Er7877PWn9AB2Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WQAJSwm0; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WQAJSwm0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747074933; x=1778610933;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xz1ICm75cOuzXF4hxmDyrPZtEk65/qK//XtPWgEHyRI=;
  b=WQAJSwm0GARwfckr+gHUPV9BZuCjnDDJqbzNV3azwk359Qoc3HPUl8nW
   Pu8bd8HssGSq3qzBAZJwAnZujZEwqAVOcEhGGabXQAA/kJVL2DtGkzx5p
   vjob9iDBwPMqhYPu/fVtEwugPwn+xZfVGAWzhDUJyHgnfjuzDJXMKhWlS
   R4FOtSMsKyOBS1xgYU7UlSdJroqW8jL/TNLLQc+n9tg815PT09UQhb0hZ
   yEQ5W/Gd1HamiffAMtE6ptdUKJtUXkv5K7QNQECg7cNPgZYhnh5iZG3Tj
   QFbdmM+rDIZt3hcH1D7imRbsCt2H2FGpSwRN6QphU0wcoNCs2YQOptVZ/
   Q==;
X-CSE-ConnectionGUID: /9wvvjq3RKmFyPLMfCwQ6g==
X-CSE-MsgGUID: mPDy1DYrQVCTjqGxjXXe8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48759109"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="48759109"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 11:35:33 -0700
X-CSE-ConnectionGUID: jdhtSTIlSTaJTNOeH7EUYA==
X-CSE-MsgGUID: nwwrS0B0S5ex0qMI5+dBxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="138394875"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 11:35:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 11:35:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 11:35:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 11:35:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYKNjl6CipzdwPyjpfvU29+hrpMFZnIaqEJhA9a9hLLy0/daT5FfoPGo+xdbMzpOWL37R72GKTC0YPvR/KjmIxztaTnC9EFw3cneqdqFNpnLRrb2s49acMlsGAAxSBDz8v3Y/Omtn2xmUEaxtS2HVgQ8oyliM7plyYWi7iCbhH0mOPkO7OC24FWcR9TcmdK/hHfh2/wXsBB4pj+m/YfEUyBfongxzQaQcZsRRD+cKRZYvcUulcMM0I3P82YIz7C+fwRILvk0cPHiU1XWQG+hLZx+Ar+rs7jZodXvavA7pTL13PcEKLWD6pHdnFbGaR3nrs7GQoNPgM2nk2fesRpy+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1dFdBXa81PfEuVyjc6HMGetKQrIsrZCa1sJrUE+mVM=;
 b=Fbvn80EkMU55qDbSSmHF9ccjqUjZdAGwMnLPqBH7KnhOyjsUa6T+8yT9PzVupeJ/bheRYjJazlaLyZJV3uY9+RL0pXqpYnsALVqvlVFhzPpTZpbc+LLqVjVgsXVgfoWvUAmoS58iOUBPJG/30jYk0NPUw8K8FWi5O48tfWb/pmKS6OsHQzTrTGYSjDWCzF7WCAbZK7C0K+Ys7OPFoxcSRLcci/FZaB5T+Ij3BiWSSZud6iEdA0zwOwf4LaFUf4aH/8GZQdmOlyP2eI36/mT0UGLmu8X7XfNyx/sU8jjOCMANaetIhgd7yi8gYlEjvWGCQhutH1wbbYZgDhMCuOxlUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by MW4PR11MB6571.namprd11.prod.outlook.com (2603:10b6:303:1e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Mon, 12 May
 2025 18:35:28 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 18:35:27 +0000
Date: Mon, 12 May 2025 11:35:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] test: fail on unexpected kernel error & warning,
 not just "Call Trace"
Message-ID: <aCI_ZxeC7r3UpkvZ@aschofie-mobl2.lan>
References: <20250510012046.1067514-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250510012046.1067514-1-marc.herbert@linux.intel.com>
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|MW4PR11MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: 7231ac16-0ea6-4d00-0fcb-08dd9183c44a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZJsWSDRMePYEhFAiXE29LnU80g4Ua9huN3YjW06BlSBgpPTZlz/QDIgjZpOE?=
 =?us-ascii?Q?UMbWZbfCSENxjeCPnNUc1y9mhQyUtk+I7vnuh8KQoIoSkQ3rbxxZnDh2zZGj?=
 =?us-ascii?Q?qu+ALLIeVBHZKMgzBXJacBjFVM1QMZEKWbRAyrZggSWE7/tBW28+ffvvLx9H?=
 =?us-ascii?Q?MUEW1gbPhGSMZfrfiECA2L/v+UhDh9lWTSl1/GolIGhYyxMNN6P3OowPp7He?=
 =?us-ascii?Q?X74EStItBs5ntFCxoywTgF3NXz4iuJHtC18feRPAWK2Tt/YkKK3mvtdcLl2R?=
 =?us-ascii?Q?5JnrcyPQbUaemciO8qg5ywpfpRhjXC80fNsZLE/2zQ7sidHKCvXfFCI2Hlpg?=
 =?us-ascii?Q?9RP7PSs2fKlJB6giDuiwedwsrEX6Yye/eF4osWdsqJyabjJ5bqGIBCc9yzXr?=
 =?us-ascii?Q?X+5cGVXgRCMKQ8lSdP+AQH1EpzV2a535Pg9ijaaeMyYVNoDSr4yUN7eMPAvF?=
 =?us-ascii?Q?L6CgDuZrLhYsyLW/GwAEGVrREYyyjBNLa6sYEOVKoHbHAHaWMwsjtHxB0z4T?=
 =?us-ascii?Q?757rL3VhgJjKWqEFrChV2g2OY2lhgTbuC9NE/Skte3w6g/1XQ1J+y/aIZ5LL?=
 =?us-ascii?Q?3yQxOC9oqxgSHZKIkfwN19Sd62x2jf5FC2GS8lwcni0kSmiSLXrpe7JaLWDr?=
 =?us-ascii?Q?8+dqdUXdql+RDpUmmB4HOq2nmd3myo7pupmcOY+WlS+99MZv9ie4PIVcgyMp?=
 =?us-ascii?Q?a1fYm4fem1hvcgMIq+BU26CGwscSW3SvON1JOGdWvRUa7QeewDOXh2Tu7fmu?=
 =?us-ascii?Q?FevSQSQmoNcJBUKpYnsNzd5Sq3jW+TMRF1bJ5tBzKpXeYcS1f/5NWn8Rf6Vk?=
 =?us-ascii?Q?GsmqT7+3hiKEddyYCAlOK55JQm0kLyHW8aFMU8q3kTFaBzuJnpkHSgIm/uVs?=
 =?us-ascii?Q?3xtsCtfaW9GqEN1/Im/Gv+fhHgHyCeaVH7NFZU/FlcaEDOo+1/ACiKvq6cSx?=
 =?us-ascii?Q?nHTUWPH6TQWS7sfjRKCKBsgEgc47Tp+r0X+Qn3V7RlmelRX5QofOZmi4zGR/?=
 =?us-ascii?Q?EEmrK57ZOe8Ud8O4fg/AgWoLbKCdfzwOKqnb/YRjOb5ogKfQ11OXdAF6xwle?=
 =?us-ascii?Q?VSW3Bur9acU/yI+8xYbVz4RzVoIFFRP/6vUTTMeiXO5DLIi4kB726rQzky7O?=
 =?us-ascii?Q?lJ6sx3muaU4m51AsA1mGUE/PF2k2NeRH6HTYEAMyWQA/wO+CYp360vRrusHV?=
 =?us-ascii?Q?ySNYLRNpgYJ03Af4MZqpDs7NWPxRRcKXSBaNyCq2GlspxqbKorZ5IGR24oa3?=
 =?us-ascii?Q?tcrth5qYLSprQHvtIViABc7JYb43uxZOtu+GGnIicr/0zLerSCJW7ifit7UC?=
 =?us-ascii?Q?WObKIOclf8aORQTdyRy9lzMM+emqi59fqtu9QNtTpvsH4mCNsUtLBcE7R0l3?=
 =?us-ascii?Q?W5PamCQB/TSJRj4+fTFDaIK4jlDpg0+deqrNsaEG8jx9ukwWFWWGhuItdFVw?=
 =?us-ascii?Q?d6tUurbRxJU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vEdaD2WBwLP9holiDPnbWfJHCCjQdpkstzHGnXFfN3cIHjlvNWTCnwRRnvlY?=
 =?us-ascii?Q?A+OfCxbY2Wl15A0KDGyHHnIkq3RzmAX/J52lp4V1Gvrx7rR/yVouc/7krb1Q?=
 =?us-ascii?Q?ar63dTdZvfEXJW6gdNXhgr9Copkr5SWovTsWuaWAM6ekF2hgjCp4LJhdyksh?=
 =?us-ascii?Q?vU/4am66jpAp44VnJ9AFPX9xR++A5V7gxD547YY5GBwGsBDC3LvdrkN8y5dO?=
 =?us-ascii?Q?ekTuD2f4HAC8KhO2iIZtMzF16mksH1dHhHXdNIQq6IXUMIqy7yQa5Z/X9la6?=
 =?us-ascii?Q?bxUDNi89WqtqpeFDlrrigmgQQA4Ow0MquYWIPzrJz/S/u0pxF4hUL6A33tLy?=
 =?us-ascii?Q?dnVOORk8glc37QwgJCHBYucNK08UuRpfL/VONA3K6YdVHEY8HPHeSVfZzHTG?=
 =?us-ascii?Q?E+uvIuXEhL28Hm5YtOleBtJ+Vzxu21YvkpsHiw2mmQzefZlQgYuNLJueNY69?=
 =?us-ascii?Q?7ciEhPEP1Ey06Ck9LFavTX9lE7RVTxe1+v0vD8sZmm7xAzWbM4j6yeq4F2x7?=
 =?us-ascii?Q?SANUJ01Z2h+WEiJxmBibjT8WjaGABSSGuDanVP0RN1ZYCZ8PZgwe1GjqcYEN?=
 =?us-ascii?Q?Us58pvm+lI4RWFsPw6XXzbbOjZriyLgjisVCR1IKaDaHzOeYdR95K9LIyovt?=
 =?us-ascii?Q?aeBI5/LUebKbz3xSNSm5URWWnRLHX7eTshB8voXaskj/YtnCkD7tI09zCbTg?=
 =?us-ascii?Q?E14mjBFD2JU0aMWlznhdFA5uO6eGNh9R53iyhhw6Lna7A0ZlsrmH02FWq533?=
 =?us-ascii?Q?s0bzUu2lF9n2MPaLYWpEgco+8xNIImX4AS9H4aSmhr5vlgQ1UR+BmbN9hXMm?=
 =?us-ascii?Q?rwdPiJ5ca5p1U4R73Op1rkPXv168nKK1lqdhsQRhfX0xkZTBxkBgu744Nk2A?=
 =?us-ascii?Q?ny3pyepsljlHhoQosUOZADiagIfLxJtp3+xBuNlitt0Gvp4nVJ54S5hLan71?=
 =?us-ascii?Q?GoAOe5MfBlJrkPv5awyGydXaKNyj0cdkiJBK0yuhB091r6jbgjhK3ps8JAqe?=
 =?us-ascii?Q?Que+ABFLPEmknjVkCAHMz8lbPujFrLKAZOSHMULjFlKOujl7SCYQlVGR9luK?=
 =?us-ascii?Q?lxq37D1cX3GtuB2P11pUSzv1AcB3P5WoUSfHbols6Bgzi3g1oElTfjLGtWD2?=
 =?us-ascii?Q?nbru+2UkrHEwzv5AXdYSxafCmsgD/jx5lPUWj+XH++fqfk30kDnssVTXzyqg?=
 =?us-ascii?Q?ptek0bpXnJFMoTu8UYV+j40I0FaEr/VlhyQcRPqBfugXaH9z7RFOwDydQTk4?=
 =?us-ascii?Q?7fSOtyFSAZv6pMFtVc1YEAcKXOc++zRjg5tFsO92+++sj64JGUi4pL4LOyN0?=
 =?us-ascii?Q?A3YjjQPPF8igG8quJrwFJjHKpgU+rnb+m9K1ZW43sjTY0YU7xMKRhu/x/aw0?=
 =?us-ascii?Q?mDk+SF1YAR/5JKCxoEIrluiTvqExdJ8I1LgBX3J3BvP4ltNrvtHfpzbOCGYB?=
 =?us-ascii?Q?htLjs38wBWsuWRjtOajDboRvTr/B6uYRCXUQJ9/Q29jvPbRvHsJ0KvamBIgP?=
 =?us-ascii?Q?EKQxHEjOpvUw0kD5jk1B/pJUR22RwEjYMICR+Yb8opqINZLqZzgcgxVHZkh2?=
 =?us-ascii?Q?vDoJmTUQ5CFwoussmtIuAjT26hiQM2zEiSNSy5uKoX2YQVIuGpfofC79shCN?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7231ac16-0ea6-4d00-0fcb-08dd9183c44a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 18:35:27.8523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZ4e4Er5GwwLknDRSVbxhK5AEb/mPwc6pg8adWkS15TpyJCOXZ9U18Em20SnHa/2OcpOcprLfUOAq5RKZwuvRCoT6Q5HPfe5vkZ9hZ9Ji4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6571
X-OriginatorOrg: intel.com

On Sat, May 10, 2025 at 01:20:46AM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> While a "Call Trace" is usually a bad omen, the show_trace_log_lvl()
> function supports any log level. So a "Call Trace" is not a reliable
> indication of a failure. More importantly: any other WARNING or ERROR
> during a test should make a test FAIL. Before this commit, it does not.
> 
> So, leverage log levels for the PASS/FAIL decision.  This catches all
> issues and not just the ones printing Call Traces.
> 
> Add a simple way to exclude expected warnings and errors, either on a
> per-test basis or globally.
> 
> Add a way for negative tests to fail when if some expected errors are
> missing.
> 
> Add COOLDOWN_MS to address the inaccuracy of the magic $SECONDS
> variable.

Thanks Marc, this is good stuff.
Since this patch is doing 2 things, the the journalctl timing, and
the parse of additional messages, I would typically ask for 2 patches,
but - I want to do even more. I want to revive an old, unmerged set
tackling similar work and get it all tidy'd up at once.

https://lore.kernel.org/all/cover.1701143039.git.alison.schofield@intel.com/
  cxl/test: add and use cxl_common_[start|stop] helpers
  cxl/test: add a cxl_ derivative of check_dmesg()
  cxl/test: use an explicit --since time in journalctl

Please take a look at how the prev patch did journalctl start time.
I believe the kmesg_fail... can be used to catch any of the failed sorts
that the old series wanted to do.

Maybe add a brief write up of how to use the kmesg choices per
test and in the common code.

Is the new kmesg approach going to fail on any ERROR or WARNING that
we don't kmesg_no_fail_on ?

And then can we simply add dev_dbg() messages to fail if missing.

I'll take a further look for example at the poison test. We want
it to warn that the poison is in a region. That is a good and
expected warning.  However, if that warn is missing, then the test
is broken! It might not 'FAIL', but it's no longer doing what we
want.

So, let's work on a rev 2 that does all the things of both our
patches. I'm happy to work it with you, or not.

Thanks,
Alison


> 
> As a good example (which initiated this), the test feedback when hitting
> bug https://github.com/pmem/ndctl/issues/278, where the cxl_test module
> errors at load, is completely changed by this. Instead of only half the
> tests failing with a fairly cryptic and late "Numerical result out of
> range" error from user space, now all tests are failing early and
> consistently, all displaying the same, earlier and more relevant error.
> 
> This simple log-level based approach has been successfully used for
> years in the CI of https://github.com/thesofproject and caught
> countless firmware and kernel bugs.
> 
> Note: the popular message "possible circular locking ..." recently fixed
> by revert v6.15-rc1-4-gdc1771f71854 is at the WARNING level, including
> its Call Trace.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
> ---
>  test/common            | 74 +++++++++++++++++++++++++++++++++++++++---
>  test/cxl-events.sh     |  2 ++
>  test/cxl-poison.sh     |  5 +++
>  test/cxl-xor-region.sh |  2 ++
>  test/dax.sh            |  6 ++++
>  5 files changed, 84 insertions(+), 5 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 75ff1a6e12be..2a95437186e7 100644
> --- a/test/common
> +++ b/test/common
> @@ -3,6 +3,15 @@
>  
>  # Global variables
>  
> +# Small gap in journalctl to avoid cross-test pollution.  Unfortunately,
> +# this needs be at least 1 second because we don't know how bash rounds
> +# up or down its magic $SECONDS variable that we use below.
> +COOLDOWN_MS=1200
> +sleep "${COOLDOWN_MS}E-3"
> +
> +# Log anchor, especially useful when running tests back to back
> +printf "<5>%s: sourcing test/common\n" "$0" > /dev/kmsg
> +
>  # NDCTL
>  if [ -z $NDCTL ]; then
>  	if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
> @@ -140,15 +149,70 @@ json2var()
>  	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
>  }
>  
> -# check_dmesg
> +# - "declare -a" gives the main script the freedom to source this file
> +#   before OR after adding some excludes.
> +declare -a kmsg_no_fail_on
> +# kmsg_no_fail_on+=('this array must never be empty to keep the code simple')
> +
> +kmsg_no_fail_on+=('cxl_core: loading out-of-tree module taints kernel')
> +kmsg_no_fail_on+=('cxl_mock_mem.*: CXL MCE unsupported')
> +kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.*: Extended linear cache calculation failed rc:-2')
> +
> +# 'modprobe nfit_test' prints these every time it's not already loaded
> +kmsg_no_fail_on+=(
> +    'nd_pmem namespace.*: unable to guarantee persistence of writes'
> +    'nfit_test nfit_test.*: failed to evaluate _FIT'
> +    'nfit_test nfit_test.*: Error found in NVDIMM nmem. flags: save_fail restore_fail flush_fail not_armed'
> +    'nfit_test nfit_test.1: Error found in NVDIMM nmem. flags: map_fail'
> +)
> +
> +declare -a kmsg_fail_if_missing
> +
> +print_all_warnings()
> +{
> +	( set +x;
> +	  printf '%s\n' '------------ ALL warnings and errors -----------')
> +	journalctl -p warning -b --since "-$((SECONDS*1000)) ms"
> +}
> +
>  # $1: line number where this is called
>  check_dmesg()
>  {
> -	# validate no WARN or lockdep report during the run
> +	local _e_kmsg_no_fail_on=()
> +	for re in "${kmsg_no_fail_on[@]}" "${kmsg_fail_if_missing[@]}"; do
> +		_e_kmsg_no_fail_on+=('-e' "$re")
> +	done
> +
> +	# Give some time for a complete kmsg->journalctl flush + any delayed test effect.
>  	sleep 1
> -	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> -	grep -q "Call Trace" <<< $log && err $1
> -	true
> +
> +	# Optional code to manually verify the SECONDS / COOLDOWN_MS logic.
> +	# journalctl -q -b -o short-precise --since "-$((SECONDS*1000 - COOLDOWN_MS/2)) ms" > journal-"$(basename "$0")".log
> +	# After enabling, check the timings in:
> +	#    head -n 7 $(ls -1t build/journal-*.log | tac)
> +	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
> +
> +	{ # Redirect to stderr so this is all at the _bottom_ in the log file
> +	# Fail on kernel WARNING or ERROR. $SECONDS is bash magic.
> +	if journalctl -q -p warning -k --since "-$((SECONDS*1000 - COOLDOWN_MS/2)) ms" |
> +		grep -E -v "${_e_kmsg_no_fail_on[@]}"; then
> +			print_all_warnings
> +			err "$1"
> +	fi
> +
> +	local expected_re
> +	for expected_re in "${kmsg_fail_if_missing[@]}"; do
> +		journalctl -q -p warning -k --since "-$((SECONDS*1000 - COOLDOWN_MS/2)) ms" |
> +			grep -q "${expected_re}" || {
> +				printf 'FAIL: expected error not found: %s\n' "$expected_re"
> +				print_all_warnings
> +				err "$1"
> +		}
> +	done
> +	} >&2
> +
> +	# Log anchor, especially useful when running tests back to back
> +	printf "<5>%s: test/common check_dmesg() OK\n" "$0" > /dev/kmsg
>  }
>  
>  # CXL COMMON
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index c216d6aa9148..1461b487e208 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -25,6 +25,8 @@ rc=1
>  dev_path="/sys/bus/platform/devices"
>  trace_path="/sys/kernel/tracing"
>  
> +kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.* no CXL window for range')
> +
>  test_region_info()
>  {
>  	# Trigger a memdev in the cxl_test autodiscovered region
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 2caf092db460..4df7d7ffbe8a 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -8,6 +8,11 @@ rc=77
>  
>  set -ex
>  
> +kmsg_no_fail_on+=(
> +    'cxl_mock_mem cxl_mem.*: poison inject dpa:0x'
> +    'cxl_mock_mem cxl_mem.*: poison clear dpa:0x'
> +)
> +
>  trap 'err $LINENO' ERR
>  
>  check_prereq "jq"
> diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> index b9e1d79212d3..f5e0db98b67f 100644
> --- a/test/cxl-xor-region.sh
> +++ b/test/cxl-xor-region.sh
> @@ -17,6 +17,8 @@ modprobe cxl_test interleave_arithmetic=1
>  udevadm settle
>  rc=1
>  
> +kmsg_fail_if_missing+=('cxl_mock_mem cxl_mem.* no CXL window for range')
> +
>  # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
>  # option of the CXL driver. As with other cxl_test tests, changes to the
>  # CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
> diff --git a/test/dax.sh b/test/dax.sh
> index 3ffbc8079eba..c325e144753d 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -118,6 +118,12 @@ else
>  	run_xfs
>  fi
>  
> +kmsg_fail_if_missing=(
> +    'nd_pmem pfn.*: unable to guarantee persistence of writes'
> +    'Memory failure: .*: Sending SIGBUS to dax-pmd:.* due to hardware memory corruption'
> +    'Memory failure: .*: recovery action for dax page: Recovered'
> +)
> +
>  check_dmesg "$LINENO"
>  
>  exit 0
> -- 
> 2.49.0
> 
> 
