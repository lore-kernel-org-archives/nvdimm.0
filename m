Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793324546;
	b=jbbUv+li5PkdC5JjPit6K2D3rlrI5Q9BGRL7qJJjbBXmYVfwlczEpL9rJgX/Gg1kAc1H
	 uABSCNVt7hw626NM9/R2rl99v4CuaSMg3o9ZAQhYjoociqi8IIjQT3H6+xBJfpIYDU4uB
	 pTjg/UXW4Gk0KZhFyqc01+0Q09w4uWNxnz1+Yqja3tlb1m+rb/2O8wGQUKDMzpyYAf0tH
	 qtbZBeQEfIM4P6P8LGKaAqb4jyhNNGVk0tRV2l6c5Oj9BGrhfI/7G8dM1PycQ0xrvYXCW
	 nb9PT5c9vO4l9fjm3GzM0yi9jSQBHTNVSjkffn1HXWIE75a30UWC8RM03iI6Kzd6utw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324546;
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
	bh=HGwkCVcA8of16gkarhtSrydmvADd1PPA9aXXZi6uWeg=;
	b=el1SQ8UNL9Q9SnVKTpSPDAkKLh4S2UfkbdPknUz3NSu+tMcUjInSgiLZ5vOaXol0dnFd
	 wgwba82M/2mDMHG9sO+i3yc+ydMxvfVCJjYZ506ZRipEDrses8yvi9pkiouhqnN73MNMu
	 uiG5KcjhnVgt9/9S7XsX4w9n5vThdiyL//gE3S6wHpz/6+5hPqNFHYifS43kCVJhDZnGe
	 kQEkw5AjDlNSBuC7kdkCW7sULv99+3f3lcQFIzKEyGQP6uMb6hZBQbLw15ImTST1ESs1o
	 j33fLaj465znD4j1c2yi41cf4mJkHrcQ/djIxPPzei8zxUNL/70AaePrdF7zEXaBDgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=byZfY7Ld;
	arc=fail smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADB4606A31A
	for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 01:42:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CADB4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=byZfY7Ld
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793324546; x=1824860546;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2cRDKiK5OtCRl1KNuXUDA3S1Lyo51JMMOjEGIlYzATI=;
  b=byZfY7LdQ1lG/XOCzKcTJBmwyPeZ7NDWPV9OYimVAkjyFWFVfZ2ehGGs
   oibFm57CctHxB+BIzSl6Cgl6Rai2U0e8OROdKzvoEkA7xLLeB1DxEMkN6
   7PUWmjf//Xv2ks9idGtVzgIrvklQACdsV4AhwjgQ8Oq6vi7RmWDiuqUSh
   lF4LLp2301r4i/n/pDMnGgh1L8SWpFxxNP5eWzTXQ8f1m7JiC9UsDwI7v
   YNMWAwYkoV/UbPAYHMtHMdDrC5ICKcZ/EMa5W50mxFeu2QeFgJuf7gHbp
   KqYCQrhw4pVNaN4zv3sEDfcgZgRTloSjquAE4iJftmvP8/0sQ2GmJKb90
   w==;
X-CSE-ConnectionGUID: XjOBrtjnSiiy0GUVfcfMdg==
X-CSE-MsgGUID: rjMR/0KbQ8yhZoEScWLmSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2074540"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2074540"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 18:42:25 -0700
X-CSE-ConnectionGUID: bDVRqL2zQ3egEvXiU8gQbw==
X-CSE-MsgGUID: +YoqqOHCTtuo3wj5vx1N8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5660689"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 18:42:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 18:42:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 29 Oct 2026 18:42:24 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 18:42:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ery3aHzxSR2g/BIjkwNtB0aFIzHs4XsYMpVwkQRvAbFhJzBt0Fv5P+x1X6u9PLG6dos5KTQPGcK4LjHy8dR/Eyphpb4Ib/hwQKSYCcbCn/CsgjSeaUMwWxVdOcugD902ee2tCPFzEXMhdKlFOE5kWZ+HBDCYCLkiyF5bHcUbzjf1YrvitLN1vuQRm1qW/S+BTM9YhaU/mskWpF6ja04K0AHvCX9gZXGk8WDANr37mJWwY4EOtRWrvIrV7C1agf5a+F7WqEHt8L8nfpjYbR6tRKLBtZijtKZhe5/riqAabTKKyvKy66PILqUmgcTja3+CHbj8y+91/4W+jmdeD+4kBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGwkCVcA8of16gkarhtSrydmvADd1PPA9aXXZi6uWeg=;
 b=m5G4rOgJldPdzA0Y4iCoFbY+qbMSQ1YTpllOhKKYxDhs0lBT6SrN7CB+Xc6ticbxtGePcfz1Tjlbxt5hjjZH5FBBBmde9xttV8E+WDn5thtZdfg4lCPgHr+HnIwIhTxMsbkDOKGxIZSn2/LV4VE0wpzFlWAPSkK6fiPCQRJo0Sq7arxCW6asW+DYlFAMyJwB/gxxa/6g9YXtROsz4OsVOuHqlgUXcyqUbCpaWNT07+NNBaR99adH8zGn3/toIvHHwcuNPotVT1yVpUfEst7Xv+cAWCl4PW8mNa/vjtiaVmD35NLmCfvbLJ9VYKzQOZmQTkRPRL9TrgfL+V+u7YiUNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY8PR11MB7825.namprd11.prod.outlook.com (2603:10b6:930:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 01:42:21 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.021; Fri, 30 Oct 2026
 01:42:21 +0000
Date: Thu, 29 Oct 2026 18:42:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] libdaxctl: check the zone of onlined memory blocks
Message-ID: <auP1-iC_4r0lF7dV@aschofie-mobl2.lan>
References: <179322248318.3398847.13424413341337264007@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <179322248318.3398847.13424413341337264007@gourry.net>
X-ClientProxiedBy: MW4PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:303:8f::15) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY8PR11MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 380409c3-40cc-462e-5a10-08df36270a32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|11063799006|56012099006|261009223027099003|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: IvP2skl3ZQgzZLkpFLjSWR7OA0EuxByWdTIlEDikllQcFzha13X4egTDOSR9QIcb3bZu7oEWqqI4GodknZLhBvpxOfOxt+txI3y3ULB9jDUgMz1O3eMi0dfiykaL0rh+AAxIURvj1/cMdjAnzNGWLrbcOK/BqDpOa4SUFyJvbonVpsQKie8lOeJ8MX7neA3VhzaHBN788kMgZFbO34p74yF8zyOZKxkDdyyuz+gcovrvXTPw+wXdfaRiYTpzjmBJnBhYtEpzs6x/G1on8uQonj7sGbjaKCh24rZnF6Bc2ljvUgb+6wt/LnRnSx7bLUMM5yOt7s+/I2TQfu82zcCUkiBObQA5GmfGpqlZndApMCg9pGhlYZVQkcbLLXtTe999gzh6fDrfWEvPRrwRzNk8l1xrUfhZeuI40zawbnLU9ttXOtquehF7TTnuuBb33hzXE0xDPV7rvTq/N0x5izyRcprRapsANOzfdB0Blk4rbdMYBOC6XgcUCFxeU2TH42dI8/5dzFtsAALTo3emLQrWYoGBu5bnz5HuqSSC6hzsDupi3xIbdlkB5BXM1SdjOEMtTfIQnvGnQXSv8xjX4tAlMAKh9vj5KQVcCgYSKxvNM6wqEZ4p1SzFvBQ9oZi4EFKJI96sbqRYo/ttuw/YTUlQM6EG65tbbzoULVytLAmRhcg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3PnkCscUXTo5Rv9SQTwYdFoNJo88q+PkZDUSQpwxUh729e8Roiye/GhRTNGW?=
 =?us-ascii?Q?0CYrp7jP7wM9RNuttzeGcsjrZl6k7Xxquwe8zs+hU9rl7QcZw3vJvMggSFPP?=
 =?us-ascii?Q?IhhaZftOU8AmY10ddgpOL4evL02Wu8ZPmUdkfG4kWve8mmaUhhmL5aflKZk7?=
 =?us-ascii?Q?wzZoJkLtWR8YxcFDbC9WbP4x7GLO7LaSCdrHZNXPebUmaztNm/jO3bel2NHz?=
 =?us-ascii?Q?r0WIz9x7ehRJOk+ms79jEoZhVJ04EvILeYx01SDrghkY4ZjVbyAm98B3dscY?=
 =?us-ascii?Q?G/qjBJR5qKchQEvXv91sHsCpFghxDFaX3uVhUey66DaZip5VoE/74eUheB+N?=
 =?us-ascii?Q?NHSbqQrkmEKjKp6HqxwkxOh/LB76oirTNImBPX/d+PInHQYfNLC9ZVW7Miwo?=
 =?us-ascii?Q?LW8qiyoGrh/9Z3x6rHWzIGnrQf6iWJCFmJe/j/nhSOQDd8B29sSuZLMcHwyv?=
 =?us-ascii?Q?P8OAv789ffsKn0TUCUWlw4eAijuicECrrQ3HXmAKliVPhDXd7e7EhZWbEwnD?=
 =?us-ascii?Q?B0HN0+zQkd7eNynwJY1K4KL6kE+3eNLpeb8jX5upsNTgg42pBK7FPqj8QYI2?=
 =?us-ascii?Q?aOLxY1+zwaRoi9YGjXrGbXcupQ2Hq6j8LMIN4ky5A0AYtA5vCH+1zEvvkEgD?=
 =?us-ascii?Q?tm7E9rJ5OQ6C35T8M9Bm5lUtbUWHGSofajK7tUZ8cBqE6wFHdWOu5N/Pbk6n?=
 =?us-ascii?Q?/VSDRtKwQdtNQ815BOnIrDDmtEkT0c7gHOtK0Fg6NTBfGkgnccCav9cqzC6K?=
 =?us-ascii?Q?qLHUbFTh7fFQEqLv86HE07Xlcu8VC/vOAiNT5rB5rvzVUfCZ2tp/R1PuNXd0?=
 =?us-ascii?Q?FvE+1QY6FISg2p+UZ5euq0I2feCgXrR3ReQecX3zesoiapq/XA9KJbWZv4fE?=
 =?us-ascii?Q?Wjo0i8Wu3ePkE6ZvpsiuKc40oTbtMqmkZnOlA5DQdlo+fE4W8MIFuThn+91G?=
 =?us-ascii?Q?jt3xejc2oxVU+ErTiuMjHqGHyprFPQoIGkJd4BVuexTLThuziq04zeCuyHnB?=
 =?us-ascii?Q?asluTUBXaEsgiVMUnaEjuHO9t1+GlJw3zO3clrIepTnsYP0RzDaLevKE4FgG?=
 =?us-ascii?Q?6OUCBvR91eXG7bPYoLOFueVXwkYzzD5Xq9Iqe6IlsQJR+pRLRbXopL9hBXpk?=
 =?us-ascii?Q?XcuouaqV8US5d97OT8TRA6tJv3Z73cMplxnalsxP6615SP+8j+cnWx2VA6eB?=
 =?us-ascii?Q?JrSfDNVZnUs9La/X8puLIjtw0PQFj4SzSd6j/10LbMyEJmgVPWeeE2a4g9ra?=
 =?us-ascii?Q?3ksBhy77RHaqfA5CQLyLUnSOR1SIJ5ncjeHOfeKAIpQLJLrt5oqxf8ANeJNh?=
 =?us-ascii?Q?8uHuiVMU/w9GOKkxqzUnAtibofoPgx2E0MyhfaB3r30ebJ0kHUsZdTzFN/8g?=
 =?us-ascii?Q?rz/SNrFuXZ8tYWhvID7YVNUb53J3Dvp3pYQmUrKP43qnqVufh4YhYCuWH98c?=
 =?us-ascii?Q?fdH7rdPXQ0nphJcYkyROBYl2rNoUqpTyFkUyoE9QcTNhhLYAF99ShDaMe5qk?=
 =?us-ascii?Q?ecjNA6IqDBIYJ4BgNl0FYGJXsZK0X9bH4GgiW2N9FM7J9wURp3gyVVsZY2C/?=
 =?us-ascii?Q?c8akh3idxsR1NHTCyY/8exr73Pzs4o69xrMB2tjWwSUjjT1NLfdsWqfhXFvv?=
 =?us-ascii?Q?oYLW+SrNHfG5i8tbkh2aBW6XHHV/m1MplTmM2rJ94KcJX8cU3skg8lWGhTNJ?=
 =?us-ascii?Q?/rVbQ07fifyZD+xXm9np4nbbfcNJUyeeX37tlKSgr8XWpQT4YJoElzEZgK6p?=
 =?us-ascii?Q?UXJwXJWesoTrNtWv2dzgqCmWdiRmlH4=3D?=
X-Exchange-RoutingPolicyChecked: cMw3/SaFJA6GGpwfqKA0YvDJ7S1iA6/PE+RoxRH+ZjQsZvAJiqZ/Bdomm6PPh4cV1innfl0axCEJ8g0u6r+MWUeslZ5CXg+fGVi0njby6fMH0sfrzdSAJWENVDPCftoNUev6ipGEUroEwHtTGTz6XzoHv3lDVM/njcyeNsdp0aGjai0Fsqt1oDq7NAhxTa0dYPheinCde85/P/N1HXWFSV4xpTgb0uFLN7l9fqLEhzUXhOEh7VAtPJKVv5xc8MkaczbROnJY2f9zdD7lEhduS/NijiWsdWS+r1wVNt3fxEnMFxOi9PHMIfvA4ZcecRXCvWisPSy4cKTYiFvqcKc9VA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 380409c3-40cc-462e-5a10-08df36270a32
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 01:42:21.4585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVvuV7DyeBFQfRzEAKTDX7qiFF/noX5jdj5YTlUK6c8555p3axQYO+lydIuQ0BsrDc0GP+FihoXDbkGurqIqPUqXZ+bvLpbRFiTtcwecxzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7825
X-OriginatorOrg: intel.com

On Wed, Oct 28, 2026 at 02:21:23PM -0700, Gregory Price (Meta) wrote:
> daxctl_memory_online_with_zone() is meant to scan the device's blocks
> after onlining them and fail with -EBUSY if any block is not in the
> requested zone: an agent such as an auto-online policy or a udev rule
> may have onlined some blocks first, into a zone daxctl did not ask for.
> online_one_memblock() relies on that scan, it ignores a failed write
> for a block that someone else onlined ("There will be a full scan for
> zone correctness later").
> 
> But daxctl_memory_op() returns the number of blocks it onlined, and the
> function returns early on any non-zero value, so the scan only ever
> runs when no block was onlined at all.  Whenever daxctl does online
> memory, a zone mismatch goes unreported.
> 
> Example: 
>   memory_hotplug.online_policy=auto-movable
>   reconfigure-device --no-movable -m system-ram
> 
>   => reports success with the memory in ZONE_MOVABLE.

Hi Gregory,

Does writing "online" let the kernels auto-movable policy select
ZONE_MOVABLE? I'm wondering if this is a race, or if daxctl should
be using "online_kernel" for --no-movable.



> 
> Return early only on errors, and return the number of onlined blocks
> after the scan.
> 
> Fixes: 0542201b5902 ("daxctl: detect races when onlining memory blocks")
> Signed-off-by: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> ---
>  daxctl/lib/libdaxctl.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 01b1915..f4b2fda 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -1691,7 +1691,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> -	int rc;
> +	int rc, count;
>  
>  	switch (zone) {
>  	case MEM_ZONE_MOVABLE:
> @@ -1704,8 +1704,9 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  		err(ctx, "%s: BUG: invalid zone for onlining\n", devname);
>  		rc = -EINVAL;
>  	}
> -	if (rc)
> +	if (rc < 0)
>  		return rc;

What happens if the kernel places memory in ZONE_DMA32?
Will that lead to a MEM_ZONE_UNKNOWN and then an -EBUSY?

-- Alison


> +	count = rc;
>  
>  	/*
>  	 * Detect any potential races when blocks were being brought online by
> @@ -1724,7 +1725,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  		return -EBUSY;
>  	}
>  
> -	return rc;
> +	return count;
>  }
>  
>  DAXCTL_EXPORT int daxctl_memory_online(struct daxctl_memory *mem)
> 
