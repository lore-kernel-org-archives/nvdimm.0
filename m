Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1052D836D
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778796808; cv=fail; b=uNz4x7DcSEvgTj8j0dS78B5VdK0Um4SzIytvoTZlbUb3bdQOJzHaHBL2iJtfjWJKHAZVikYg+whB89fIleRQVjs3PsPBOf4w4yeDR/0iLp6Ei2EZIVCX4FhDExKbqHp5s1c0P93UTJitoOfr6qy+cvAhj/1B0GtaP5QXLQ3pDGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778796808; c=relaxed/simple;
	bh=QCsqf6mG495kbXcAuH2jYbwgRtnfDhTpWybriQfV4Vg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i9qgcD0ERZyHgkvPPNWwDC/asyyyAeOyvW1f76ssm27qM67bxfPAgPx2zOP8Zjg7Aw5ov5tujHB9hTnlwSuvLKdlNLYY/rzuldOoNQN0+30XxgCXP2q6mh/7KZUMke1ecvUy9GdRN4r0IGiZy67HHvzu8s10mktf6+YDcoi0Yjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c+tfqEJ+; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+tfqEJ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778796807; x=1810332807;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QCsqf6mG495kbXcAuH2jYbwgRtnfDhTpWybriQfV4Vg=;
  b=c+tfqEJ++ApO2ATSYMiYifP9b7ybflu9lFKOXywylhTjuG7hCIFO+EYm
   wKIxR2ACSTRXIUQ8x47Q+N5HFbFG8huyjUAop84CFdmR2WIWH18cR/YI3
   nnpDgkjYo25ph/nY7NSxzV9sZQX9lXRY2saiPmhf4TongnhOtnzKiGJWg
   TGZfCHleWtrT5Ou37PZ+0+I3qgi1L9JbcmszZMP/872z0xotjg6F39lhY
   1D5Fqq/v9n06i4uJa1dNCuU47ePJwhJAgIAlwNSCAnY7uJgN3YjipZwmK
   jn+Ls57C3Y9trjX616IWRdtq9Gz6YY1NBEPRXLc0F12u1FeUn1bVah+bQ
   Q==;
X-CSE-ConnectionGUID: iCTRTWmTSIagnxiloHTP8g==
X-CSE-MsgGUID: iTAr0RsTQ82/SHkQgQH5VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="90851346"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="90851346"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:13:26 -0700
X-CSE-ConnectionGUID: /TZS6K7ISPaCZX689tVK0Q==
X-CSE-MsgGUID: IWh5FvXCTVKcJ3dP0dVnHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="237515104"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:13:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:13:26 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 15:13:26 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:13:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENSLf/2061PlljFkPHQNCFbNH+6Z9d+9++hMvr5JiRHQR1wsfxW64UkqmeFp0eHYCogu2vmnDkrJECGrKBvM5mksotmImb1qEov2Ojj76PphkjVIDPhT81VCbATYIuumdtM6uTEc8zDgv3yYkqNTQXtuSum6IVpzGf0yReeAH5beU7U9aaTzFyOcx/lFbCqFt/H3xHqYOzFx7g+jWF0v+MPP4HYz5mJpW8OJfGE2+4JDF1IcR8poJe9lj82wCds+zLJRW+63uCwGNomzlc53ARaZ68kPPc8qlWGla5yVg045FebPgToKtEaJFfQwx+VS5loVH6xmHg+zfaOYtuquSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//v9FNAhyDJNBcHpV6FEzaIUEvAp8vWe+4xjeFVx0GU=;
 b=Qb7l12FT/fGEequdNKs20s28Ue3B+U/aBdbI09cvVDL4LKASUmFItPpKGTCM7mUuq98Pdtx0Szgz9KGJ0n06olS4rK0bbclzHHWDxZo0GddWG88m0b5pmxmOTCbw1dIhu2lpAE41DyLiu45vC7/rSRhd7sZuEHs7HjYdIvaCclFdkaGJ40wKSG3sDX/AWe2S1OJnkf0jq51lCdzYfA2d6NqgZ0x0Gr2UWHOxhj0C1vQzSrODgxmosO9SXhgz5dne4J+HDKpvOc0/2BLVxhFE3XozU+FGiyaME9Dnxtefyul13F5wv/G0Ue2Y7BIEOs74iQ/3ShswuAFhjbS1dxFOQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB9183.namprd11.prod.outlook.com (2603:10b6:208:57e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 22:13:24 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 22:13:24 +0000
Date: Thu, 14 May 2026 15:13:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Chen Pei <cp0613@linux.alibaba.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <guoren@kernel.org>
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert
 when driver is builtin or live
Message-ID: <agZJACMViARKTp8W@aschofie-mobl2.lan>
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
 <20260514063234.86439-3-cp0613@linux.alibaba.com>
 <20260514193749.0f0750e2@jic23-huawei>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260514193749.0f0750e2@jic23-huawei>
X-ClientProxiedBy: SJ0PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB9183:EE_
X-MS-Office365-Filtering-Correlation-Id: efdd4d4d-0e71-4256-e5cf-08deb20603fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|11063799003|4143699003|56012099003;
X-Microsoft-Antispam-Message-Info: 4ol9ca02vP7PGDsM4f+jntFBY6IX3Sy9tKmakXmg4LrsUDSy9oM57Y8JtFnWzY18+goKKljM7xPzatxJzqiU7aMJFpLQnPEf+8MimJBi8rDbIrUu4tGA3BI7Q0PVuCaJ9fplFLgb8Mn6bgiaQtRxJGlAEPTdHbNMrfePM9H8uPHsUHsEilHFC/7NEPx/0j9TzhSwPm1ysfsYx4zz5mPpEZOBrh46jU2xRQi+Hm/Q/ydo44u/QUcGDdsSSqe1CHQOwCLs7klJJeWd4jDMATd2xfq3A4fGNWiJhDX3igHj0KnEYkspmHxfk8eFwpkVoEU/yf59B8/oDMVgDIVZTLixvBrCsitnEisBTPOUAz/El4W/wf4md0V/8byOGOj+KEPTJt25npUXTolKHa6kQusjVJ9+ia4k3V4Mwuw6eXBSzwXGNVvULNzNgTD0yTdZeD+je6I71HqN8iDOaLycXgJKT/qPYzpOh1KqicpnHjaAZVzo+1tmF+ydWew0wiRo9sAQyD43MenFPhh5sxfg1TtdiUAHDrn4u2Xl2ekQHJYeUtIyi+YyT2ki7zPrsJ4c/fjEB882Bcr8eKeqAWvnX0pPV9FGcMw07cgeJ38y/xi6fgcXam9ErHhIWPKEA6OHajoTlKSa5EFo3fvFsMruw5NqfmPZt7FuFzj+btjmIsi038fQjBPOCad3c91I8diE/K2hBGxfmQ0DP6O9SsRRNBBODQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(11063799003)(4143699003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1+rDxmQRbz/jQEkU3r92hFcWBrTPGArr5Vh41YDxr0Nz5THLl4/K2ofIgsfg?=
 =?us-ascii?Q?1HBUanQpreabGBJh1cLWgn9G7IUJMe7Hn3v7QQJ5/DcJk/qNllx4wTqZCLWY?=
 =?us-ascii?Q?HDLdFkPQRhpL08XB1YKnZxK6anttKmLRarPrVCYSTizIEaLhu1cqrS1q/69z?=
 =?us-ascii?Q?Ga0lhxPAxCEzjif6V0b+wNMlfiuWAF2NiB8+2CefNoPowYOFTVM87WBR18xU?=
 =?us-ascii?Q?bBeMoMyPMb45VQ7rEDA0qJ9g9qeOYRNesNT+unCIiTpxWC9Eim3FnIv3N2Cn?=
 =?us-ascii?Q?5mIvqDUoSCKdGOACPPCv62shNcVY/RhRO9qhBpwFLAAyBzhxr6r2j0dJmHYR?=
 =?us-ascii?Q?bkI6rwN/ro/3nCUsmqDTczdAoh+VlpTHdi5RBMyHNyh/T536Rld4MRE8ebiP?=
 =?us-ascii?Q?qeWvTfG+lNf0Enm2H3BrMp1M0ODUN9Milm6pn/MpMxHho9zmzsNQ9HLWp1vY?=
 =?us-ascii?Q?FK+0i5L5jkeLK9mzn3kIBpyjMe9FNBnhvOQifnsqpN0apZ4L3ZrfQMKRGrUv?=
 =?us-ascii?Q?W8eMI+jVq4260st4sDixCLgAyakLJ4l5Bhg3tngJSBH4j9d1mws7vUwknUOX?=
 =?us-ascii?Q?jY/jD7xJA9mvXCYSid32d35e4fp+jwt8rAZeK4UN6AEuQ3Wdxy8pImveE0uv?=
 =?us-ascii?Q?Nbv9ZfvLkgEsqIjBvB7gYBJ0ZOqgfdh+JR+eRVoWWUplq4OoxgcF121xZO6t?=
 =?us-ascii?Q?MEI1HCedIeNSF/O8tGD+oz7pjQ5m2VphCBFNLSyHwWsITT8X6ft5zLiMZ8qT?=
 =?us-ascii?Q?WXxHGovZUddydIE3nM9S99pCybi46CBEyxPd4xk0e/u6WbtZTEPQS5HHbAgS?=
 =?us-ascii?Q?udG3jt8+yNuQ5mLBMsnRhWQ84CNU+Z7tnpW1v+gTT2LgZl10HMEAIwCWnWUn?=
 =?us-ascii?Q?ZlFslu8uyTO+RMIAZyE4hWXWE8a0XgWACfBl1MhXwbQ4GJYR2PjfvQotPEqT?=
 =?us-ascii?Q?2Wxs1f5L+uk8SvSrtvwhZQhf1B/NufF0R3NmVgl34ins3ZSFFG/NSWu0WXyI?=
 =?us-ascii?Q?ZepAB+dJq5Qr3ME2wWdKUjeahkSP46MbHgYQvMXLswL5YtQsjQxEijiLTrlU?=
 =?us-ascii?Q?MVyuJDdFe4sMck+/w7G2r/kzME7Bl7LDNFvCf/U0s/6jTtQKTlgt7sPg9oHS?=
 =?us-ascii?Q?24w3BeCB7spIMiuVlgltmQcIUfSyrKOoIOt6QEvcMjA+oBi5ub7Pva+b3zQr?=
 =?us-ascii?Q?yUhoWROGaXFeC31RYA12+foP8MKxFj8ClF1s8WuiKnJwET19nXcJnnE1Cirx?=
 =?us-ascii?Q?ws+KrT55e+8L66u0Y6miAKdGOSAnQ2Lpmgay7a8n5bHCngnceVs4t2f223AM?=
 =?us-ascii?Q?XT0zrCr9PJrgf2DZVOvoD6vpuFI/t0bNvSQmoQ62EaVAm1MAC9FaDUfmNwan?=
 =?us-ascii?Q?6IoNEN4HVudIKJ2+0V5SMoEi4HfM7ViF0ECJcV2WG+S9UOVoMuor6LYCIk+4?=
 =?us-ascii?Q?a67X6aTGoSYq58gzoRwdiXRf2GmfAUISYdSTJtoGabiPkBlBnPSWbscDR97q?=
 =?us-ascii?Q?hzi7C6SO4RCdr+apNN91LcevBSBtpormUtDfzWaLwjX4sgyrXdgwn6sNbUj8?=
 =?us-ascii?Q?P1u2AGFEoLTEswbYte/z8TGiXdJMGnb0ugCSwE93QJdRvyyURn+l+lybw77N?=
 =?us-ascii?Q?pJ+xc8EZprFqzHthKWURkvOJlOX4wIXymId+MflRZ9It+M/RnhLncIL/EjA2?=
 =?us-ascii?Q?k7E7GCCDrkeS+ikNh1Zoe6KU13+lKxoTFZmcnwN7Eu5Vo3vmf0q4ix9Ed7UZ?=
 =?us-ascii?Q?6sYmF9IarX+x/zkX6RwfB7NZn9RDhq0=3D?=
X-Exchange-RoutingPolicyChecked: u8wQkw5dAaAxC7hqaTNEFjeH0XNd19GbpB6Cx6pXaxL+5c+prP6PDFMTP9iLY3xASstc8KdYkKlwTjSbGAQ4OR7nOV1EvPLcWSSuokeXX6yQPLlChqOA3ExVw8YXFZN408ouMKZEsuTqT9xdUi+QnDXXFHolNXheuqJkqLWDnN9xFBQnjFIQXa17kc/X5VGkzXYKoZVcjELNHJjUzffqBYDFdMsTZRX6ZyMMc364p8vbt9u9aIb2zhaCkYaIXnMjjybOO47oDAvHMF+DYZnmViq3hIH2P8EJRSCmihyx+hgdyhezkPKV0t/FIC1PHT/wkyt1nEsiqDisdSG8FmBcxA==
X-MS-Exchange-CrossTenant-Network-Message-Id: efdd4d4d-0e71-4256-e5cf-08deb20603fc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 22:13:24.1564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8brrv5QbLr9vMHd14Txxo+0MRAK7JT2u0jFGpvdBh9GU5ykgICMEukLg2hwuDWsSYefqIE9mdE0DXeWU6uwLeESdjxM6KE8MuPY/W7kQ4Pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9183
X-OriginatorOrg: intel.com

On Thu, May 14, 2026 at 07:37:49PM +0100, Jonathan Cameron wrote:
> On Thu, 14 May 2026 14:32:34 +0800
> Chen Pei <cp0613@linux.alibaba.com> wrote:
> 
> > kmod_module_probe_insert_module() is supposed to return 0 for builtin
> > modules, but only when libkmod can locate the modules.builtin index. If
> > the index is missing or out of sync, libkmod falls through to the real
> > init_module() syscall and returns an error such as -ENOENT, producing a
> > spurious "insert failure" even though the driver is already part of the
> > running kernel.
> > 
> > Pre-check kmod_module_get_initstate() and short-circuit when the module
> > is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE, matching the pattern used by
> > ndctl's own test/core.c.
> 
> So I happened to run into exactly this print earlier today and was
> very happy to see this resolving it! I'm lazy so when developing in
> a VM tend to do everything I care about built in and not bother with
> installing the modules.
> 
> However - despite having CONFIG_DEV_DAX = y in the kernel, I'm getting
> a state of KMOD_MODULE_COMING which is curious as there is no
> initstate file to read that from.

I think this patch is worth you trying. In libmkmod code I'm looking at:

https://github.com/lucasdemarchi/kmod/blob/master/libkmod/libkmod-module.c

the "module directory exists but initstate cannot be opened" case returns
KMOD_MODULE_BUILTIN, not KMOD_MODULE_COMING.

So if device_dax is builtin and /sys/module/device_dax exists without
initstate, this patch should short-circuit before attempting insert. If
you still see COMING with this patch applied, then we need to figure out
where that state is coming from (before thinking about special casing
it in ndctl).

> 
> Looking at the code in libkmod it seems to first check if it can open
> /sys/modules/device_dax/initstate and if it can't checks if
> the directory /sys/modules/device_dax/ exists. If it finds that it returns
> KMOD_MODULE_COMING which seems odd given in a fully initialized built in driver
> that particular set of circumstances is normal.
> 
> Any ideas?
> 
> To me the description above is misleading if we need to have something else
> for the builtin case to work.
> 
> I'm out of time to today but may get time to look at this tomorrow and chase
> down if there is a way to get it to work.
> 
> Jonathan
> 
> 
> > 
> > For builtin modules the local kmod reference is dropped because builtin
> > drivers cannot be unloaded; for live modules the reference is retained
> > in dev->module, matching the post-probe-success behavior.
> > 
> > Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> > ---
> >  daxctl/lib/libdaxctl.c | 18 ++++++++++++++++--
> >  util/sysfs.c           | 17 +++++++++++------
> >  2 files changed, 27 insertions(+), 8 deletions(-)
> > 
> > diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> > index ffc81eb..42bfc39 100644
> > --- a/daxctl/lib/libdaxctl.c
> > +++ b/daxctl/lib/libdaxctl.c
> > @@ -910,7 +910,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> >  	const char *devname = daxctl_dev_get_devname(dev);
> >  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> >  	struct kmod_module *kmod;
> > -	int rc;
> > +	int state, rc;
> >  
> >  	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
> >  	if (rc < 0) {
> > @@ -919,7 +919,21 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> >  		return rc;
> >  	}
> >  
> > -	/* if the driver is builtin, this Just Works */
> > +	/* If the driver is builtin or already live, skip probe-insert. */
> > +	state = kmod_module_get_initstate(kmod);
> > +	if (state == KMOD_MODULE_BUILTIN) {
> > +		dbg(ctx, "%s: module %s is builtin\n", devname,
> > +			kmod_module_get_name(kmod));
> > +		kmod_module_unref(kmod);
> > +		return 0;
> > +	}
> > +	if (state == KMOD_MODULE_LIVE) {
> > +		dbg(ctx, "%s: module %s already loaded\n", devname,
> > +			kmod_module_get_name(kmod));
> > +		dev->module = kmod;
> > +		return 0;
> > +	}
> > +
> >  	dbg(ctx, "%s inserting module: %s\n", devname,
> >  		kmod_module_get_name(kmod));
> >  	rc = kmod_module_probe_insert_module(kmod,
> > diff --git a/util/sysfs.c b/util/sysfs.c
> > index e027e38..641b86d 100644
> > --- a/util/sysfs.c
> > +++ b/util/sysfs.c
> > @@ -183,12 +183,17 @@ int __util_bind(const char *devname, struct kmod_module *module,
> >  	}
> >  
> >  	if (module) {
> > -		rc = kmod_module_probe_insert_module(module,
> > -						     KMOD_PROBE_APPLY_BLACKLIST,
> > -						     NULL, NULL, NULL, NULL);
> > -		if (rc < 0) {
> > -			log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> > -			return rc;
> > +		/* Skip probe-insert when the module is already builtin or live. */
> > +		int state = kmod_module_get_initstate(module);
> > +
> > +		if (state != KMOD_MODULE_BUILTIN && state != KMOD_MODULE_LIVE) {
> > +			rc = kmod_module_probe_insert_module(module,
> > +							     KMOD_PROBE_APPLY_BLACKLIST,
> > +							     NULL, NULL, NULL, NULL);
> > +			if (rc < 0) {
> > +				log_err(ctx, "%s: insert failure: %d\n", __func__, rc);
> > +				return rc;
> > +			}
> >  		}
> >  	}
> >  
> 
