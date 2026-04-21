Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1741175A6B
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 04:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776744354; cv=fail; b=YLEYKQHWMMLqmTXRVDq6AeKVuZRcpsLcGkn+vyW5tzgMSGh7idNPyDTbY6Gc3QfR3VW8BHnlNutKxv5gEJFRKUg8BJqROprui+HrEf7VS9W0qZh/JF1KbvtpR8FEYWPvg7aLiFo4EFXUCvMTBWOfbTeFIQ11ONxm9QC7qtzhG7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776744354; c=relaxed/simple;
	bh=xHJLwlSrOaEJkV98EUU1WSXyevK05zz/S8AkKR9W6ac=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T4eqhCV+2X614Hk0VG1vneqlevS6ltGZD4uWSRl1h/MEb01Jk6SiglCCtcPFUa3eFTk2SovkEGmwxgPHUZdS4hvZF6XOGJiScSt5Hhdp1KpTWUqWzMsYXAhuM78Omsu+usKpqIBOjlyCFUaeHwCc4D2sx4OEiboBN04/xBGq/Dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LppC3GZM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LppC3GZM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776744352; x=1808280352;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xHJLwlSrOaEJkV98EUU1WSXyevK05zz/S8AkKR9W6ac=;
  b=LppC3GZMFaFkeP17jxG3FaMT7BWbtBrhTUYFrTaPsIgz0EqI7SxFSp3L
   XnRc2K+fWyLSx/Bwneulmrv/vmE9K/Zdc/vL5F2aBOfFmzuI19Jm5PaI5
   ySxQ+9TWWnnpthnKNU2crhWsybMr82PLBaA6iYAm4Jq09FsNIcgQsMQKB
   pm/RESzf61nrh1TBFtRqY38MqyrFtnnpuXvPPvgRs7LFtC1cImFLM4Q9i
   wqyWUAPbug7cdO2hwleuuv2Z1+CA8BJsCo95gNbhSrU9YmiPp+khgA6Kb
   UVsbOTncKgTjPozEykh8gyB1Ge1249jUM+mS+h7Sy8wVz8vPeF/aJ5vYb
   A==;
X-CSE-ConnectionGUID: ad18YRyXSEOgz7IA9G1gYQ==
X-CSE-MsgGUID: gD7aidhuQ32CBha+JAfBpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77585550"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="77585550"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 21:05:51 -0700
X-CSE-ConnectionGUID: K2gSdeQgQEONtOC56qJh4w==
X-CSE-MsgGUID: WkAcg15TRXaUFcyiZzRjlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="255182191"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 21:05:50 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 21:05:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 20 Apr 2026 21:05:50 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.54) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 21:05:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nj6KGVLkCljtilVA68grLzZQRQ0Uestjr+u7OBbdX5mR1m4J9snVQ8p6R4onADrV+rPZ5EX1Wot/myv1fSRaZpljUCNDFDSzB+8Ybv1pR9mq1s7gJA/YRDL9T3XpDT5CvxMKGeCC1gSrx6RN83fLyT7IMIStyC+deLc6LRMk2S2vu98ldG4Zu8T2zyR2IwiptLwFVA3cxE1DX55D+JF00CWSfnYrzQZzdPQi9wuhITePYyMKAepLp9polGyVSUyjDF6vWy2yAkC6ECRyeXmPunfqAhMG8hudf3srYDJyblXwflkPnU+8Ouf40+lbGr7Hu7QE6V0FaNq3mJRYOyZTUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFkK+EFZIbjWqbMkwSO/tcL7ljZdoq1XVj9xerCHZaU=;
 b=H3sSaWzLZdpOiMCY8JQDF36wkZzGk68+iVlv9cd6N1vOANcn/yLUT7AhTAvGWsiHJQHW2fuVsxVZaw5Ahh+1Cwsy5emH8dfqhSA8j4hNULP9v/XlvSiLgVch1PrQ0B74DNojgl24ulBvu+pUxJM9sVjwav7uVK2n1uWctfc7JvQArxYIpIMhvI0VVDhcEqSvGw2xgPXPLG0BNSFtJJhNFrqst6Ly//fDoVgnk+eJV0ACgWrZrWYXH2Ge9/etM7YAFJVUOoDqbSRupuy0vv8od7wKSWSbbSiRV+8Cjinzrgmafl/IG/+CcPuw/dO1TwMk/U5WkyNgTqhILsNiXuEnNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB7403.namprd11.prod.outlook.com (2603:10b6:208:431::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 04:05:46 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9846.014; Tue, 21 Apr 2026
 04:05:46 +0000
Date: Mon, 20 Apr 2026 21:05:37 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
CC: Terry Bowman <terry.bowman@amd.com>, <dave@stgolabs.net>,
	<jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<dan.j.williams@intel.com>, <shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
	<nvdimm@lists.linux.dev>, <alucerop@amd.com>, <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 0/3] Enable CXL protocol testing
Message-ID: <aeb3kXkeAkWBm-DW@aschofie-mobl2.lan>
References: <20260408203231.962206-1-terry.bowman@amd.com>
 <7fe63454-9df7-47c9-ae7f-4db1fd1a3576@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7fe63454-9df7-47c9-ae7f-4db1fd1a3576@amd.com>
X-ClientProxiedBy: SJ0PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB7403:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db1dddb-dfc7-46c0-ad2a-08de9f5b43ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: Zh33dFful7UN1T6Bra3BOoQxj180zOoCpZLLWENdr5/w4nW4zitPJKBhtIfHxuOwWB/W8i2BHNrjdI1ADl2uCTMHmJH7O9WRZmsujfNUTrQ7Mqgq96MWx6T7hJW1mQf08MbfLDYdCpDVUr6xWSLZe+Sqoijx5C/yZUsFJlslAVoZIha3VuEFmKPs8SA6rlyX5J382ZYIoa0yqT3rmXgEYD+Wnhrz+34rD33DNA8FQKLAoLFHmJJAUB8hrVBIqlzG7cs6gOhRA5oRY05vblW9hB7AKZsStRk2pisVMzV68XvrtZPOkkjzlpG9botfZsh7Ya9tF3zeCEH9CKsG8tykcPH4IDIj5enbIJlhfgnHQU4lJDcA9tAvK495w/YZKowVXmvbjk81kNow+3s5cPyfA9YQfbZybALqgBEOwDAhn3/h1FeOushif+qsUibbKDK1za9cuNjeMTXA2V/Lz6x12kv3NbDMUn5gXSYQpeOFFBS7O83//zzfdVvdnyz7dE9ivP02udX+YsI4sRtw/27pp6udGTUOKMX/aun8q8ESHjNNSceiF3RyVlACWCXrDFcRJBgb0eB3KTmxOWiUVQhtTO0+UIPfg3wcNQHHP3yeCXtFMe/9wRcVjCNuKFYMDFlEgcCpepFTEc6ULJ56l/PMJuGxr0ymCQsY7lBTEo2fJMN/q/vJ9DpRMOSvp9hVaVOU5FXNT+cgR47WsYHLqzCszjr7IcZdZ663fxzxaW6EUyIe4Q2cOMO90i0Sw08cxWNy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BOYz2fdFX9RyyxCmag/QDGUeD/C89lr4T+8KUvtPndS8msp3Xo/XkZUw4ZuT?=
 =?us-ascii?Q?p7hCAzIoTYkSlJWo72tbKwP/rSqakwJPR7Dbs9rKyhBZibf9SS/av3ETA9lt?=
 =?us-ascii?Q?vBE8j2gMq/xJ6r8CXm3fflM4Zx+4tSCG2WRmGI9j5sfAG88S+UUbAd0TdrCB?=
 =?us-ascii?Q?ZOHNi374MVXVXxsacAfoLwhlkap3fLavXoGBo/v8bKJtHSkiHRkyrlOdKtif?=
 =?us-ascii?Q?oz4bz3gYu3GJRjb105x+/+zjwsT1UB1H/8yHBSZBAoL0LscW2rKhvKV6ZAgQ?=
 =?us-ascii?Q?puSwT99OINxJbHdBpNHjj9nI0kPfofRvQXU4qC/AUIOPBn7BcYsAU6BPQX/g?=
 =?us-ascii?Q?/sh094jOUuVzOPZsUXqeZLr5YxpALBIYXG4UyQ6g3sTOpivgPx7on1wrO6U/?=
 =?us-ascii?Q?6cj0SYpeMEokebDPZndJeePwD4gsu/vLqeWHbwzwET3LUZRmpvBCTWcIKL5U?=
 =?us-ascii?Q?+Vf3IdW53rmjPM99Co3lUTeM849RkQCUzTEH7AWfbtN65BNdMPAw6sf2gy04?=
 =?us-ascii?Q?4yyx37GT/2xTbkpGx+FfaH68HRmsyobm+Jrlb2qLSlwnyO1x2N5DcLwd+5Dc?=
 =?us-ascii?Q?ER+LJVbRA/k/LUnPcxN0h1tS/NxFNptOxofYTcb/iDqMSaCrcxthwGN/5E5M?=
 =?us-ascii?Q?L/IjysfyrDa5FfvtirPGi9iMEoqe2ggXaI4WR9xeeYYVQMbE8oW/NWQKWKbM?=
 =?us-ascii?Q?0jvQDdQkasXwKjBjoQvAHlkFOyMds1cNNLUz+apV1iZYMbf6hs4gKuLsD1d2?=
 =?us-ascii?Q?Uj7s2MxvtbaBz4DKPzPOabG+C7e9pPfMLGGiY3+VKMI6ZxnnTqychedo1OMS?=
 =?us-ascii?Q?TDQy9Z7OChk8wzUxnvh7YRil7N93/AIg93sdjMNTEkDVZW2/uggA3JPQ+Z2H?=
 =?us-ascii?Q?PuJc2xxBOXXBt9fLzJqz2DMxBmZYeX/ioKhPsKIWPIXoSY48Un0oIAp5k2rg?=
 =?us-ascii?Q?ASxuLlgqJfj2ic9LluHSPLMLxzxL+SSBT50lQMR2J0YnNkSVHyD9f6I/Gj2O?=
 =?us-ascii?Q?9yv1jdAlu6lspKBLD64ILVFyopCA3F4lmYCY7oCk/9NL/hNVaD8fJo+JHjbq?=
 =?us-ascii?Q?Kzbgf410o3ENDpgcHo9pJqdOgQMOXxF1oVlQ8KOfeI/xMTrzxKh3D5yk839c?=
 =?us-ascii?Q?XBQxeidLoL1OaDlRoB8dcRnkHwgVs8D6HnfNd4T5RywsPcMJ3xvRHz/W8kAf?=
 =?us-ascii?Q?HcURmzCwY/Mcg9ePmDU2X0gFOAbrIlMj/haH61kyJgqtl3s910mWPZc3tDf3?=
 =?us-ascii?Q?zQITdE//CkgR6y5LIBg+bMW9nhu45ZYN2KAKmXTIqjsbM7/au++EavQK85P9?=
 =?us-ascii?Q?1Zh2gNWTcT6hKpqU/RlrtmiMkm+BZ+LIdKxnFoJypqB2ZxO2QPgp+PgJoImN?=
 =?us-ascii?Q?oWpdRSWTZPckeag05QI2mMVtcxqDkTHa/s1juMaWkhT6HCILyHOmy9x2kP0u?=
 =?us-ascii?Q?bcTv9UmgyGHY1SUZ/Amy1x+kOyUeTU+yd1+uOiqXA2GtDtS4QZEDqB6gZh1S?=
 =?us-ascii?Q?EAO/TpsInzWcPsG1zbRLovIj48aO6oQ7H6dmXKjPB1Oqfqk1tCu/XlKAGHD0?=
 =?us-ascii?Q?n1i5J3BOLj1p+H33pyv1b8GSCKEcCWBktzY+soLsprkBO4dMf3QQorH5rac8?=
 =?us-ascii?Q?2u2CTqBAkDomtm3uyjqJJpDtgIOFPSZVkw01rQQAjdFL/7pJECvay73myp/E?=
 =?us-ascii?Q?K0D/Fz85njbTxuTq6zzHL7XU3G6Q+wifOSua3khnM2vwKBqgBta75DhUSpFd?=
 =?us-ascii?Q?yBvR0uH7/4QGUaJzXIfnoA5Jbq/A/u0=3D?=
X-Exchange-RoutingPolicyChecked: FpdaGyhH+muYAdPmENdyFE94MVXadrSea4cqVNSPxVyjSn93jtkn1Vnd0ePuc4VVybFr4Rbdsi6v2he4WqQCoWyZDOotjYHkJmMwvd/mPFtlEgGFOwiTP+kmBqMUshxXc3Vtk916cDFZObY8XIq7Vv2Xpgu0NVGGT8Y49er449xkF/FZLg1SatViuJesyMAnVfBFrHOtWpDBfW0MDIGZ029VBWSoHDzd9mZrgFta84z3bTkkwsVGC4Bp62n8l9+eT44+EkUvZgIfLpcojYIIOGrvkEAKETZWTayAXJx9Og7P395lWZ6j1oVPvL0akCgB7w2F/Fz1Qp5FzcGS7vgcAg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db1dddb-dfc7-46c0-ad2a-08de9f5b43ae
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 04:05:46.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uF1cEVQxQr0Q9deThY88f54iEOcbeAsfQypE64OE1A+NCaIBR0FowJayCfGUIGK5K0sP7d2YNoynKq0spsX7NHkSqCEm2zrtXrBccfGYmIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7403
X-OriginatorOrg: intel.com

On Wed, Apr 08, 2026 at 04:39:41PM -0500, Cheatham, Benjamin wrote:
> On 4/8/2026 3:32 PM, Terry Bowman wrote:
> > Current CXL error injection (EINJ) only supports Root Port protocol error
> > injection but a method to test all CXL devices is needed. This series
> > outlines methods to update both the kernel and the 'aer-inject' tool-without
> > relying on EINJ-to enable CXL RAS protocol error handling across all CXL
> > devices.
> > 
> 
> This functionality should probably be added to the inject-protocol-error subcommand
> instead of spread out across the directory as a bunch of scripts + patches. The command
> is only set up for protocol error injection, but I don't think it would be *too* hard
> to extend.
> 
> I think the first thing you have to do is expand the accepted device types to include ports and
> memdevs instead of just dports. That should be simple enough, there are already helpers to find
> both based on sbdf, name, etc. Then, you'd need to change the interface used to inject the error
> based on device type (is it a root port? then use EINJ, otherwise use aer-inject). All that's
> left at that point is to actually call the aer-inject command with the correct options (and
> update the documentation/help messages).
> 
> I would be happy to help with any of the above if you agree with the direction, just let me
> know!

Terry & Ben,

Terry thanks for sharing all this!

Reading patches and Bens comments and trying to understand the pieces
needed to make this reusable. Help me out here:

1) expand our (Bens recently added) cxl-cli inject-protocol-error cmds
   - to handle new types
   - to route to aer-inject tool

2) make aer-inject tool handle corr/uncor internal errors
   https://github.com/intel/aer-inject

3) make cxl/test capable of do special RAS status
   - maybe a wrapper

4) then we write scripts that run under cxl/test, require aer-inject
tool AND what else do they require?  Does this require CXL QEMU devices?
Are they doing something special in this recipe? Is this something our
CXL Test mock devices can fake?

Above is my quick attempt to understand. Please advise me.

--Alison


> 
> Thanks,
> Ben
