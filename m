Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A32643ABC
	for <nvdimm@lists.linux.dev>; Thu, 29 May 2025 02:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748486714; cv=fail; b=MsUEUm0P/2tJwuPOmY3P9JCihCGlmrYtSiS2lZcVpdhrK26A+oPxQRPuYE4AJOK7ijS1jTT69DzoeYnEj7IuyDTiJasegxXpdHAJptJ4ZboNaGCBuPCY5ARbijF4MJNXSvBsOf6RkrbC6XTBnvBAZr+AwSdF54++AM/B7cVtDBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748486714; c=relaxed/simple;
	bh=tpt+zOOJKrk6iFLpdOJtJ7WP5lOjsiIyikophqrWLoU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PNgwdS9mC9Q9rpc9/8BrmQBbbyr+MPXzHExPPHCGXyQW1P8RV65dXKKxbjH3dUOjOduliWCVIfl18uqNnVMU7TqsncyQmBsLXxkPgkr8hWGl+SEpoVssVdQkidwaAyXjZfor7fN6iS6AaXfwHhuzyd0xJ+eQxSPTZNGK0h1wa/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SminSJQk; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SminSJQk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748486711; x=1780022711;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tpt+zOOJKrk6iFLpdOJtJ7WP5lOjsiIyikophqrWLoU=;
  b=SminSJQkGuSTfDufSdsUFl9stPAbf2rQEEDz7z9HRDFZkmnx195qmHhJ
   IW/WcuFksAbdeqFogBHnwhVJ8NUVh8mW3xY/OS/1if53EFDov8t+nhgHq
   G79qg7j9smSRjmRao+kmSHQ+WTm2p/F1Pw7mgNlm/DKqNl8XZlKxFJXs9
   goMiT75RCZFN0jWsE4dFmDX4XiE9Z5Z9BIJ+/sUz2J9JY0cj2fyyK5inu
   5Cc9uTqQTL0QU28pAUdESmTPu1nWY2yYW7X+MS+8NAIBeuaErPBtO8eqg
   V7RJxDHRxjZ3t2XNFtieppGje7aWSNT0yakQGHBmGH0F1LffsBOT49f9n
   Q==;
X-CSE-ConnectionGUID: 8CoFWj8TQf2U1wl7XkoCJA==
X-CSE-MsgGUID: sp1Ypeq9TsyHrSXohm48Rg==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="60793991"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="60793991"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 19:45:11 -0700
X-CSE-ConnectionGUID: quZRUAtaTyidaxzGJ1Q9Rw==
X-CSE-MsgGUID: 3ujX0kDfThiHRbOUapdi7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="174422087"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 19:45:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 28 May 2025 19:45:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 28 May 2025 19:45:10 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 28 May 2025 19:45:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2DC+bD3FlrymVmP3CaiSQTmPrMnQIYi2JovKwwaPsGzAjF+r6TTyPIoVRfSkVFop++I2t5cSjiLQe7rfi6l4WuLT5FfI68DpZ2mKO1RR8F7UqQaDF18rsgc0k1wKxk/UqgPGtNMmjzNNwblQyyUHZWZ/JpuB+C25IDPMjgZADvFiPMGGIZxb148YY+kl+6kcxLo8Ot2viYmDs3P7iKFbTP8yjIz703okbjWtwjb0pfIlP9Z8526zf70DgYyFTWEMzjLNyAXrvw+YdC3jRJbbblTl56idNtD+iPo/WuGonLwOYmwle94i6kn8XdtGmNwGBT9XY+4ZkAfPyfyJOEtWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLjMEEOx8p52pFtJe+AJ7MjyZaKM+DeRJRg4NIc1dho=;
 b=R1qke1KF/Bqb8wkYVgxkoZleJiBw4OzelY8XdsX2/9GmUxSfRlXKTh4K+s4s8/1N00hnhBfc66cQVOXRKNv05FSb9bWJXLGyDFMGlcYHqyQDZdeLinu6bXFeaCu1e2oTQvhMv/LiSOqm44OG37V27XaeAhbQ+wc0lWKrtumZ7dFEl2IfWzbEtvagz59Raxq76gHM5TRauSt2M6uxOq0ikCFYtK57/TODwdHZ4fmIJkr5CkF//JQmC4gUFq4Lk8l0WEb0SvlotIhuJQ+RFFr5iUbgTxtqD1rvubeaHx11mSCW0fKa1qmM0uddndqnYSCcU6oLcCQ1hGjAlYg5EiajsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by IA0PR11MB7210.namprd11.prod.outlook.com (2603:10b6:208:440::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Thu, 29 May
 2025 02:44:27 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 02:44:27 +0000
Date: Wed, 28 May 2025 19:44:23 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <Marc.Herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 1/2] README.md: add CONFIG_s missing to pass NFIT
 tests
Message-ID: <aDfKB3juX-F5Cld5@aschofie-mobl2.lan>
References: <20250521002640.1700283-1-marc.herbert@linux.intel.com>
 <aC6sVpma71y4jH7S@aschofie-mobl2.lan>
 <5c712edf-3cc5-4707-8a5d-472ede773b6f@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5c712edf-3cc5-4707-8a5d-472ede773b6f@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0189.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::14) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|IA0PR11MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec1a594-8ab1-45a5-1259-08dd9e5aba69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8hOQ0VLEgBGhIxKzX4fOaxwAcyE8JV+Oo1FUc12nqProrNa978I9Q3eCyt4u?=
 =?us-ascii?Q?hbxAPXpESXOCOUumBW82GDksQiqtaCBo9MaHLkJ9InSKQGIZtvisjtPZXYls?=
 =?us-ascii?Q?kTQRkENf3lTtND7/WUBJkicQHukiTBT/QuafQ2q5uDzgZrXVZL/6CrFtlEQP?=
 =?us-ascii?Q?hZBzgl66Ye29FzcRrbCaEH/y0T/i46tb8kK5o/NIi8iKaP6pbb6MpBfzRAvi?=
 =?us-ascii?Q?hDO74rm1UXm/7d3c8Ph4KtNB5qZloW6TrolQAQtb9+qHLwMfSZ+xB4fFzetg?=
 =?us-ascii?Q?8w8F8rbkRXX2ux97Y5RpFYq3a7gwB6vk4jmvLbaCEPnxe1kjB9lT15MFF8zt?=
 =?us-ascii?Q?+pkfZJZvIq/+dB6FGWFPr+PzSJRBCoUIelVVZCtvoCBaWPY8UqQCqEAWzZ8q?=
 =?us-ascii?Q?TRU4s7qp+asra4usF5smTl67ayxXj4+lw6f9KIl68adAIHBwUUijej39iZj1?=
 =?us-ascii?Q?0+XiEGYzH+JGX805P3oVEXFFyzw/eCyJ7V2cr/HhS+9quRBCdtC4+cVjlwHu?=
 =?us-ascii?Q?I5lAQlzGqH0oi4mbdSTP1jW3+odAoBTIQA1OfPnq1LjS0cGxSKgobZHseTWg?=
 =?us-ascii?Q?ZH6CTLqf5AMxsmPyG6qMGsoWic7JufBS0ewP+ixBwB+VC1FrORmKDZg14Brv?=
 =?us-ascii?Q?InxXCpKK0PS67g6dtEnTP6Y/dJ946k5qkMDyToO/mStYF/jdB12GO95zhm3M?=
 =?us-ascii?Q?puWxE5Xmca2eedOryLGwu6JPlMYCelxCpUnWPoXaLtE7mtnb8tXKn8nt0BN7?=
 =?us-ascii?Q?iz2NAXd6iMfbUhs2l1r3wsyZliv/oers7dgaIpJJ+HZ1dXZxvonROjQSgAuj?=
 =?us-ascii?Q?Zp9/2jb2pGkz/LEG/1u0kVEXrVW/z/rFoi2RlqMiIYmvCaxEkq0EoRkc8iSa?=
 =?us-ascii?Q?4+ciw2R0vFeFFPA2ZDF640EMTalmfiNSbbpMENfgR5/6RCGW+Q7N8twb9WyH?=
 =?us-ascii?Q?kjMyHdVo3djwYs1pbHk+qqus/GMs8cmo5slFOB+5F594kBTAI8QrPV6iB0vV?=
 =?us-ascii?Q?VyT+82t+2TpjmH8Hx+2/T6/NNR0goZtSkGMAkhRaCxRGZAh7YIZ8ErX/mBV4?=
 =?us-ascii?Q?sWtywgQ/bewP6NaM03yofVXHlsR73fabW2nA+csn0rup0rb2DioFr1TTwTil?=
 =?us-ascii?Q?IuWDKNyEd/AYnH3rDZX9OwTfHiGBJcysRAHj9dyWR6/GzxY42634p+rvHzS4?=
 =?us-ascii?Q?ouNiCCEbr3sJEM/uNgpVygaa+D/ALa6YYUOhtGf1b9U7LBQ81102juwCuEPL?=
 =?us-ascii?Q?A4tJC1GJp1bWMS3lhFs6THWC3tZsq+ugCN1TPuGh5Ym1AGhor0ONsFRNAne/?=
 =?us-ascii?Q?n0bWoV0ldu/hH3I7lfGdmYi3v8yVGVlKwwmrr26qPBmW3SkCucdeQzZbuRtA?=
 =?us-ascii?Q?2TyOT7+S1K8D+WXHAO4vanXS1UMumcaJB/WObTSgynVp4E1a1zm8A1LVq6ci?=
 =?us-ascii?Q?AePehe33MoEt4wKlfS5pf4zVXy/kaNhC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9IQCAIW9mwHw1S6tD7NUTgAYgp/Yh6UIq46h6nAAr88crahYXHrpzIj99KR1?=
 =?us-ascii?Q?E3tGFGRfkEzfNuZnQtkrF1bMTay3TxEKPOjPBqwlNXZmYTDvPjDXKVo2JKPc?=
 =?us-ascii?Q?Cwo+LOaaN4OhtxlfKsdPI8CyX+yCRtdVle9a8RpGIpizWcN1/92ehESB2UHp?=
 =?us-ascii?Q?LH3A8zzecBU4MDASQ2XsHOZoza/6seWZ8IZaBRWQkNDG9iXSsfkqhzAD4fLb?=
 =?us-ascii?Q?CAIxAYg70kqGdyfD72c3fouBDQ95StjVEVPLpJw9MjstdUxl4p5KpmPDAMNY?=
 =?us-ascii?Q?uMzuzmqDQst06VXE7e3pycIXvbLhZzQomrYTZVLahjD2Qi0figtzY6EyBrD7?=
 =?us-ascii?Q?eD3t1XGMKCgJz0zYq/x5JWuLp/j/QZnGqzBYMyf+LyuqeINIGx/io6zDzgHe?=
 =?us-ascii?Q?vg1nza9J/Jl9SDV+2YVJFQj7SF+zq9cN7VgDEbc77Wgc2UwUUYPnKeIp64ac?=
 =?us-ascii?Q?RrKe24WEHNqNjQbmdLo+/bsiQ44e3ZC0mBxCa5kFtOAbO7DFNToE/rWxUxjs?=
 =?us-ascii?Q?6uQPXHfqEYupEcEHxz4F34xVcMwS845Bqu8H6g7VGR8TenCEu5TDOeiQABMJ?=
 =?us-ascii?Q?e+2sL90x/FfO38g+iLOu7i3ufHoMMRc+DRbDoBVYc4WkNiHwJ6zwoC5nEBYg?=
 =?us-ascii?Q?0hgxTomTdTfln52tYgzEOsJw7rzaS5EZzZQF8DYK4TwX3Q/gwHp7oB5HGj2A?=
 =?us-ascii?Q?cLZoB3VLkcG6GG30lzavGeunirg8ugh75cQaLbroU7wbeMkgdsZNS0eLRi7e?=
 =?us-ascii?Q?71yBEWpRQVL4nj869/+OpR7CXxKBfo2O2kNsxASZcjFsKVVpJ16/zAbakAU7?=
 =?us-ascii?Q?WStpfMJEBxoZHBLLqLXjIQF9qR+sXk5BGWW/C3pARoVkyJEuT/DvyOoJqNLS?=
 =?us-ascii?Q?7CwcsL3EavOeHJu7PKTO7hJ9Cipli3yVkL6oIcQqPwr3WO4Ix3wohghbTUa/?=
 =?us-ascii?Q?gaBBIV/b1mZI/hY9uKh1aH6VRzxb7v0JKnl9hfaIDBmqOpUZNF924gGE49Yd?=
 =?us-ascii?Q?RMkLOxjAkz2VWBXiPSH9y/JiuMyQ12IhRnot38pg2qtME/35mhzG1+GcU2BJ?=
 =?us-ascii?Q?SU28pbrNIcUCU9Ocb4AL0djY/u/w/cvTFL8IazCV6SeJqHrUn38wy/pJeJQa?=
 =?us-ascii?Q?ZO1veysMOkgp/5NgKVHJzIyxXTOmKPPEWgDt2fa0tduRfJ6s+GnGpmFGYCNz?=
 =?us-ascii?Q?Tg2R/LS+ENq3WCAUwBlXev6fzDSZf/5r3/0KDZ0D1Hr8zetMZoPAuNTedXDK?=
 =?us-ascii?Q?/K3sGgHRoRLSDgwqYWb/K5bDkQvnOCpeNNCzuTlwdVio+1wDnGIELEaWk82+?=
 =?us-ascii?Q?6ZAQP34aL9/1O6CrwkA5AdHcEfRgWMltZsP6PHoLAkbJzy1pCGOXzB87slno?=
 =?us-ascii?Q?Db3s138osWlaomebGvS049QBaRkjDicbrCIBYMFi7FUezoAOSFC0iHcDSVIj?=
 =?us-ascii?Q?w4FIAgCYTgtM9LqeUvCi+LJu5SIu5dK40udu2VTt/GOHxxRZkgFhxShEQSrp?=
 =?us-ascii?Q?Q8RlMQuvy++/9YIYM3WkFsu4zuEdcnQB4hyesCG/cjBV+JIzICOi+MKxiqFZ?=
 =?us-ascii?Q?wTuNOgaYBBM7HJe2ocGw0C1K4OWOVmMpxNU35T92kkAQff3zs0d0jx4o+dcj?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec1a594-8ab1-45a5-1259-08dd9e5aba69
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 02:44:27.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGJTuZZON7UsKEJks/k4xS08ldYrcThnGLC2VlXaesDva1+ahKgojzYeiv3bvVNc88EL0PsKkS80ix0YoTUYKMGU2Mt6iRd79XQyfyQalzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7210
X-OriginatorOrg: intel.com

On Thu, May 22, 2025 at 07:47:56AM -0700, Marc Herbert wrote:
> On 2025-05-21 21:47, Alison Schofield wrote:
> 
> > Thanks for doing this Marc! 
> > 
> > I'm wondering about the need to delineate between what is needed to load
> > and use the cxl-test or nfit-test modules as opposed to what is required to
> > run all the unit tests.
> > 
> > I believe my environment, and yours, and most other folks using these
> > environments are doing so in a VM so it's no big deal to load up all the
> > things.
> > 
> > Maybe just a gentle separator in the list showing required and optional.
> 
> I unfortunately don't know and understand these enough to remember that
> and it would be very time-consuming to re-test them one by one.
> 
> More generally speaking, this sort of list looks deceptively simple but
> it almost never is. That's basically why I initially asked in
> https://lore.kernel.org/nvdimm/aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com/
> if someone more knowledgeable could do this (based on the
> run_qemu.git/.github/workflows/*.cfg files) Also, this stuff tends to
> evolve.
> 
> Now that tested versions can be found in run_qemu.bit, it's less
> critical to update this README.md file. The current README.md version is
> inconveniently non working but at least some functional versions can be
> found somewhere else.

Hi Marc,

As you probably just got notified, I went ahead and massaged this one and
applied to pending:
https://github.com/pmem/ndctl/commit/fb2f28cd280c69a978753e54a0f67267e54ffbda

There is clear agreement on the great need for this as we encourage
more folks to join the cxl-test club. My comment about module vs unit
test was a no-op because the README, it turns out, made no mention of
that. I did pause a few times on the README and say to myself, 'oh that
needs updating' but decided to get this out and come back around for
better later.

I'm going to ping Dan directly for an ACK, since he promised :)

If there is any issue on pending I'm happy to fix it up. I'm planning
to make the v82 release June 11-ish.

-- Alison

> 
> Cheers,
> 
> Marc
