Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7DC46B5
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 00:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744159345; cv=fail; b=LknOSnuk02PiD3k+zrfenxcJw7MKIBMveBfa9W0cThQztjotXl17VKeTxxld6P2+5V8lZJODhpOh75Vm0PRtwSaeVmeFN7zdlIJs33UNFruZbkFW8hp3UmWEMmbE0+e0kgfZdCqC/kayyutlKwhEZbTCChBKRnaVmxsrkjWl6Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744159345; c=relaxed/simple;
	bh=RYsBZJPLgd2jxriuxyQdK3DlVm1PUpzoWh+UbGNJJSg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uJ7aFnPMZsp/6BVLoLknWW7HEqHET3+8IhCrUqEtzKn1S6EAr20rsr2Q1PDC/qtYd/o61f3rOgBYNAl5qnl2/N4pv1158d6W3SWS6uAUOqT7O+VBwFz87ourxh7xv88kbR2XpZkqlL6vUOrNbDMCvvVCrXK1d1fEkVBvD5DRbpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6aglV5m; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6aglV5m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744159345; x=1775695345;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RYsBZJPLgd2jxriuxyQdK3DlVm1PUpzoWh+UbGNJJSg=;
  b=W6aglV5miynUpXgC7mdAqz4+Yj+Dq4aewOH66NL9FpeRwCFS4ZaUT7tw
   Cvl+GqAniRQO1o/wExMkFcKNBozvH8Jb60y4kuVdo0u4Ypo40xeJiS+an
   MfmF+CWc6Hs0tZI92tneywEobQSG8vNrtiLg0+QP4OpEUhF789k9yhyXy
   KdSKOHYovFbr6v5eFWV/UWzynv/hb0IPPdYr4URaDfRc8CToVOOrrTozy
   J9Xwd2NE0Nt4uPA9GSAOGquQTsM7iqNJLu6N7UqI2LROZwZRqiBTfRBfA
   lTcDpsX8gKKl8VebXIBP03Rt70ZDZNryZwtmyVNWafCg27Y52VAvXQzC9
   g==;
X-CSE-ConnectionGUID: B42rD93xQEK6KUUZIdur2g==
X-CSE-MsgGUID: wSF12JCZQ8qMd1BFycATJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="56985958"
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="56985958"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 17:42:24 -0700
X-CSE-ConnectionGUID: ec1QmtJ4TYeVHhN84xEdXQ==
X-CSE-MsgGUID: 7fNDELUpQOGQ1bU7qTwZxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,199,1739865600"; 
   d="scan'208";a="165657812"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2025 17:42:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 8 Apr 2025 17:42:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 8 Apr 2025 17:42:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 8 Apr 2025 17:42:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gB8q22bHIKv4oD8l18mRBMx1Ss5HoRMMSSozKQTi0c/xY6NQSJFJA3HAjDcSGCxREuK5HPiVUO0fT5YGLfCgv+s1UKNMh9EjPpHxkVTHfjD3i4cuOFVesN+PioQuX8B0giKmvkjBHpISAa0MCN1ko86Axym0mFfMWCxGHcaw4h9eA9wWBUlbnVeVxACHvogHy3csHLb2wGjwTSn4RwdwCgIoktNYC/zKNCzgfLNpbOCKcAGKAiqqlsUBNPa5eqqLsgvMLFePUMTDoKj7RBCrp4WEIJ/C4iEyZ+vz116NFYgUFiMlgED/aKtsF3Lp9HiUDkglYLMfFIIe/2JMR3v4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DW+DgCpFHbJomAgxOf5I+r5mTrF0VIVybXyqFyhOo4=;
 b=UgCIhlGikf2BFAvFXhDQ+sDOEUbbtwMU2ER0PDZvlzfwuonBQsJuU+Y5YSsY74Qd8LjuDRAYTkINWTPN4SiixGvYxwF0geaY5RErSER+ggLBd0d896fpLB4Rb8m6/hqYSX29bA+hnw6VuT7NzRwnwO0i/LUaMYAtoEhFNRZ/X4PmGWrc0x1ay5A+yK/IudR5Z4O8KoistOjid3WBi2BtQoCBRlGNYI/Hadwge8pQSiUE9o4avsHMXGBevWC+wdzZzE32BqEI3SsPzSyZK+7f/tKgRuW5X4882UZKBJK1iDyG8wYD11ZpzOCIvZgA0rPOWLSKuanLSJjosZLO76z0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DM6PR11MB4753.namprd11.prod.outlook.com (2603:10b6:5:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 00:42:18 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 00:42:18 +0000
Date: Tue, 8 Apr 2025 17:42:15 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v4 1/3] cxl: Add cxl_bus_get_by_provider()
Message-ID: <Z_XCZ_WkgCJ1wh-W@aschofie-mobl2.lan>
References: <20250218230116.2689627-1-dave.jiang@intel.com>
 <20250218230116.2689627-2-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250218230116.2689627-2-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:303:6b::17) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DM6PR11MB4753:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fe76faa-fc47-4d07-b0b0-08dd76ff619a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?32XdbWlmX5pT6xZX+JqzEJOrEapMdlxqBLEspG7picsE3g3/hTGTOYn7jsOK?=
 =?us-ascii?Q?xV6GagJfO8KPcq563YQWebUjoQ6bYQBuN5VTlZiZ02PEpIdV6A1mWdDMuNFb?=
 =?us-ascii?Q?ns8TyPvS6djncZNe9xNnJnY4OCAa1bRz81gT8fWlTxl3X0HY3AQOHvgG9C3R?=
 =?us-ascii?Q?BPKUUEwh8GtBxO/PXRDkS+IL5ho837i9e3FTfv+gHNLEubCBfeNBRPdEhgxe?=
 =?us-ascii?Q?CzQc/2+iwtfLef5gEoKDSpSqfJDhB94qpvY+hDP3zuyH0feq7YraJlvQikAl?=
 =?us-ascii?Q?2RkIjKXppLbWfQcUgANCKFgylLHWZVNcGhDXClENn03BKpRkcAOGdILWOUHC?=
 =?us-ascii?Q?lhGg85EUwOcTWb7IPinmrpl/Xsic8Z0lAv7BPwVRni9dx1d2jlV46Ud5jKIZ?=
 =?us-ascii?Q?WFxB9GOzQDL+LerHr29pGCx1eBTL3DapNpXTFhvrB4JNjTr1x3sElHatZAcZ?=
 =?us-ascii?Q?nfteQDbnvZOBgyPgnAtOQCk5otRmWvAvjGc0zUx/13a/Bl+ztJ/O4h7Xg0Y3?=
 =?us-ascii?Q?3zxsvvMGc7nvBqk+wzCim+a5XCU2VYhSJJyOVutI1whgH2xI2NWQWbmhYt63?=
 =?us-ascii?Q?yiEbGj9UxltFpn5J7AAyNQ6bllNrn3/2VBma55aSBY2/3YGxNuVRHEO6jYyc?=
 =?us-ascii?Q?zDGCQwlXsvTQs9fiGIun15kIUfSc/Lrv443GedXmILnfEGBVUD8FvlRLwIze?=
 =?us-ascii?Q?mfeTPtDXZpn0sNjrDv4MhgNJcY8UJR7B35QfOuqw7DTQO/o2FcOdU1hYo4sn?=
 =?us-ascii?Q?6J+Bo8ix5YkM2nH5ZmrpsskD4O1zRkCk/OE11mvZBPa8Yyubsf86ZLKNY9Hk?=
 =?us-ascii?Q?6S/RnuLNdhdV9aVEdvHEOuJIcLZ4JcsMzPvsjfsyxl2YeltVK6mFCpt9hSBB?=
 =?us-ascii?Q?1MgVbbGEWveTE8Wyow9VeAH3gMOcL9vDvHow9H3MK1gy6dquPevFVQPMdo3K?=
 =?us-ascii?Q?Rq4MYcHf0V+7SX/rqC9A6TPYPMxZIgBm3ZeB4DOl+A3PjTFrGsJJxsjy6qq3?=
 =?us-ascii?Q?lr7SV+ZaGK7lqnivoR55TGktB1r7h96Lkan/RxOCtdAD+WRu6jLy2Rj1+W0T?=
 =?us-ascii?Q?jYLmqfyU16p8ruSjM/J/uDZ0P/yu+iXhp0+z1epqM+BjZOltxhmiPattGSDy?=
 =?us-ascii?Q?6bhGZaU36y8NwV5qwJslQM+NjandZqV4ExuXauDK6iRm+5TH6c0IA6wL+C+G?=
 =?us-ascii?Q?hrhVbzo6GrGBrHjHgjS8brrNB+iCcEFS9GTLDWyx6l95g1jzViWH5es+6AY1?=
 =?us-ascii?Q?rg4910lhC2yEjC9RgQoHBtUKTB+xhN09kkn4F9ayNDcUPZzz/nv7C3oWUQc+?=
 =?us-ascii?Q?/ITUYgjbrQiKQYO6cY2zycpkYmUBzKRJ783hrfG6uXFJ07ZMyQt6qDj4SSPT?=
 =?us-ascii?Q?ZeczqijNOOGbIVgWEP/fWmYybs4x?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W/suRfczhZLwXVQQKRPFSKxGn/JpyjMN9TV4aJ6cUngXM9B1/kfHKlKL6JOC?=
 =?us-ascii?Q?F+ydeP7q4vWIw9TAWGTSaOzdO/wdNusW/7ssjv7Dhji0TyvFWWor5TScZvx1?=
 =?us-ascii?Q?lAcUODrPCq/70K8OBx1IJ26VBjZx9VgMbUUyokU+b/1B/NfaEhhqlR3H2jOh?=
 =?us-ascii?Q?9SoWiAEHYPm6swynNytzkGHcHTBah5xCcuU0veZrsq5dBaw5awiN4mN/bt54?=
 =?us-ascii?Q?zJCUAeCLJKE4mk29WK0dfkQoZgQ/eBFBtPROhZOGTDVNcSygPmKKaLKAjdw+?=
 =?us-ascii?Q?S98hs9wdaf8Hfj8oKsDi/t9+oaDpX/lCjmvgSGMtYKzeJC3N1D+ar56UZKmE?=
 =?us-ascii?Q?eoOCO++NfkDzvLUfOVlGj0d7ahx1XvhhW1PV9Niag5wYIu4t2mOe0XxTf5UJ?=
 =?us-ascii?Q?aM2lryWDRv4pcMiYvmaQA0btYIHsGtProOyz6obyCknt7+D8ZmagrwnWV2Gy?=
 =?us-ascii?Q?GUoEVDgVgt1i/cBuR1tGchx2zst9lsvaxqgvbKJdV43vqN+C6ZJhOpbQkj8w?=
 =?us-ascii?Q?sztOb9w5xK7bUV8GbW0I8t22ICUzgK4O3hJWDxl/ZwRccOJsZEnu4GoppSkL?=
 =?us-ascii?Q?55a58aqJP7QjDYXR2qTy8r1oVuzPuV3yrMWoK/cI+18vGqhhFDi3K7ULodCG?=
 =?us-ascii?Q?YikJPu5Tm86WJX3Vua1L/rWxqQiSFj1l3EIHPQyv4UpgcMWgly3B30zKEVBf?=
 =?us-ascii?Q?63NwGekCnOJLxlYMgWetObHyGFRpDNrkt2YlLowJkWHLaFVBFBHj0I0hO0bc?=
 =?us-ascii?Q?QhWUAmlIFVs5NnTY55pID5ymsvvDEQWRA1xBnD3V4baVN81zeOS1MQqq65Dh?=
 =?us-ascii?Q?SADspKZKxhM00q0q6HRFgNtHG7W31AN/gGsn9M02UAKCUTRe/FIj2mbgaazw?=
 =?us-ascii?Q?9wW6FfCi+RHjcbzPpOXTuECKjldzcZdZqlndUW2wJ3ydbx/QysAnsqm1fFnD?=
 =?us-ascii?Q?KmI+gk8ZBit0gh/KfaShguMWBTUWIz5MjgvLMT+5Tu1Wwtaw2xz72prry1pN?=
 =?us-ascii?Q?4wkk9HVXXXnrZxatvCzqpnKJ5bUnajENZoyc1xM5f2Enx78fq38A2sjl0Xx2?=
 =?us-ascii?Q?dvupML0QNK2CyuXv3JmvXcJC8Zc8yTVX/WyZs3ZpEz/u0svBHD0IisHB9HdP?=
 =?us-ascii?Q?Xg1X6ubSQ77DjMZLlNHBO6pDv2y3jHFsJn4gI7AwNP6ck0g3Gm/oS+EvvZKe?=
 =?us-ascii?Q?vMeFsKXWprLL1TUpZeck2w7A/rPwT2otcILS/2TkJhmPJ1Ly09l/V4luU2EI?=
 =?us-ascii?Q?yKdfItyy/YYMgD2oIPtqf9r+493LfAaqwD0wAJxbxJaMF2JxDGDBSgQom0Pd?=
 =?us-ascii?Q?eHbXq0jK+iZGYLGhxlTZ4sPLlyAn3le5jy0pXtj2Lt1GhyB0UO2c/E54Bn0D?=
 =?us-ascii?Q?pxhOQCbLMqz8WtYVHk7fPvFQn/JssEOO1njO5Brcp3JjdzBTm8rlnqovSvkH?=
 =?us-ascii?Q?hU17rc/I7nu4V8eyLgPC4Jb2jSdGrpotadzqDmAb9pcYf/2pv1uEaUlDGjyh?=
 =?us-ascii?Q?JBpTwbA/BKdtyXXeDHvg8LICJfJHhv/sDYTN0NtoDlpRhuFwBfQLzDdWzsse?=
 =?us-ascii?Q?TpK2ihKX8Exbki8Au3bZ/6ZKFWNCOsySu7rFX/ARXihSmhdFtchVvZE3lPgL?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe76faa-fc47-4d07-b0b0-08dd76ff619a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 00:42:18.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkvC32BqU7dCrpG8+krubIiwiudt+5rffXTDah7N0CfF92CRNuCdh1K524ipD8Fq6qf9UG+I7V4+i4hxlZpMC8EF5IG/+L8fCD5Q+YL4yik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4753
X-OriginatorOrg: intel.com

On Tue, Feb 18, 2025 at 03:59:54PM -0700, Dave Jiang wrote:
> Add helper function cxl_bus_get_by_provider() in order to support unit
> test that will utilize the API call.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/lib/libcxl.c   | 11 +++++++++++
>  cxl/lib/libcxl.sym |  5 +++++
>  cxl/libcxl.h       |  2 ++
>  3 files changed, 18 insertions(+)

Please describe the new library interface in 
"Documentation/cxl/lib/libcxl.txt"

Add To: nvdimm@lists.linux.dev

snip

