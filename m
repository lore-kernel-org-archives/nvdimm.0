Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A007222172B
	for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 20:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748465624; cv=fail; b=X+3Wl1LOYy2fQHfR+4ETSjq63uICnhNdZLI31MGeLNfkGFst9UrYX05aOt4af/WTzWXhdfA8Kb0qdYf6in8J3SjX46qUPvda0H2WdJSwJKfAJAOe8zB3Kuzo+tG0zvnopmGE8ZoNMibzG3ddI5ExxTmKC/ODHN+n6etVcED3+N0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748465624; c=relaxed/simple;
	bh=2+LwO/XXl2Uzp9RoA4ZLPc86CxZRSbF+3IG++F/TmXE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qD91fheZqzs5ETfo+G+Gu0sw8XSB/6nBparD0AMhefe842f1vFkniWgbO2WIXNmzfWhULZ9D/r2PrDhxdk8bfAcBX9QCC3sRAULiz29SKcs9mcBE0tz6iEyJgnZLW1wljc+N5pKpbZ1CuBXj2BgCXoqVF5QItKWtZV5pKPR6cH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FgHtNpjR; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FgHtNpjR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748465623; x=1780001623;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2+LwO/XXl2Uzp9RoA4ZLPc86CxZRSbF+3IG++F/TmXE=;
  b=FgHtNpjRaQTkdPsmyIQ9D7OTsn4IU20RgJL+bhLgAcRqWjbZv4a+LYjT
   iK4w1BWlLmJu64MbxGDebJWtZSWw+Scx1Zd7o4ewA3j36C1BeB7V7IhXK
   lsepHiKOkHb2k2Cpi7p7oWI42aXc2oMpccpc3DKc+7mzDUS+s6hvSjtiy
   gC9v54MYdkTxia2u1HNB1FZuG2/wLVOeELhOhWtnNEEkzTAXQ6ndE280b
   DbQfQXM06BmRrhsm3BFPxvmkz/AF0q/kqbC2KjRJD3xhGVVjaeGTtiKdY
   ymr7Z0e6g5ZsHdhUD8TcF5WsOX/vSouXfteTIRGJHeU2StDavR0z/AtGh
   Q==;
X-CSE-ConnectionGUID: QkXC2jImSQaOHDO8x4qKaA==
X-CSE-MsgGUID: qpF7XnaySz+jaU1dvq+xzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="61860147"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="61860147"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 13:53:42 -0700
X-CSE-ConnectionGUID: s6DDvVvUSzmGGi5cBBYWpw==
X-CSE-MsgGUID: FaDKvZJRSQqNFIqU6BZZtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="143683041"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 13:53:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 28 May 2025 13:53:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 28 May 2025 13:53:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.48)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 28 May 2025 13:53:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JyfywxMwUMDfTdAfOr8y/8si7wcpzBqHcnt8aO8oFpKtariHigUmJrLpIBxZL1ImkXim1wfqI2LrABwqB6Y6nOUwmeDzxVCk+7Zm8rk0KXeZnavf5yig1SKW3HXAxcH0WEQrADYi+y5omlIWsNeRBI0M3GbrwAi7M0jGikibOigBunzgPcG82ahVO4hw96cv8Z7lxADAL3ZclbOwCSYcAOY3lmxKRNw5yvTgPuCjsLoVaP2uuIUkMfZ0+b0l17tbtHMzA23gmd1rHbGc+P4fPdhWANMPWCnXGgD5go6mqMVZCuUqmGyAM8UXMu2nIJoSYF9w+KfeMwrnGFjcE844SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcS3nA0+vnuGYpdwQeWxwTRmtvqmUu/hBdwO74BedTs=;
 b=p7Ko8wGqLSl/17BQsdwu9K89YAiXTN/IwKczYzdnokYd67Mg0W9wHYRYRT32cRibK6pmHJUETmso/z3gquzifwx1c/TJ3qBw/1ekXftWjqF2RXQrx7lrmN/CSB1aewrNejf5ji/7X6yyp+zbYqoKrdb4RKHuZ0EBwathVyBX8dVk9n1oGGK6CI1KHiwyTmqMOO3EhTcdHcMxI4cKaWJgoP85Aa2xvTLABTsN/FNAKMtSlP76jAOj0DQb6+V14VBBB8qNLm8x3h084oObp2duhpmdBTyAA+POoi7y+jT3SKs6/PYeedM9SGXgbdr3wnS3kyObI7n0noLKnnZdwO/NRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Wed, 28 May
 2025 20:53:38 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8769.025; Wed, 28 May 2025
 20:53:38 +0000
Date: Wed, 28 May 2025 13:53:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] cxl/test: skip, don't fail, when kernel tracing is
 not enabled
Message-ID: <aDd3zjguDlKR9c8g@aschofie-mobl2.lan>
References: <20250523031518.1781309-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250523031518.1781309-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|PH7PR11MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 68b6ee8d-7be7-4305-530a-08dd9e29b84b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?l3EbWNrfVJx6fBFLGlLwWLoqlzJXnYRRnSTraDWlwSUobzWoiKwRAT78Y8vl?=
 =?us-ascii?Q?PaYrqSmPB4fkvPJ2tWD5eTb+5bxZLkxgZKgl3UQJC2/PHBWDCLUNKnmBjry8?=
 =?us-ascii?Q?bWH6kG6FWnTE3M0n+3NsCuiNk5SLJxzuR5ZI7CZysKfWMHrFhv/dgjS/fido?=
 =?us-ascii?Q?DpDIBw73OD6Ou3sZuWdDXOQrEFVKU3ZfHaKV6070OJZ/9AAJRfrt0cLob42G?=
 =?us-ascii?Q?so0aE5xm3Mx9LQd1fE66IXzifrRSqRGT75tFtpvfkNyy+OpsqBwXNyZbS3ac?=
 =?us-ascii?Q?KnjNGEZ4Amjw83wO98C4SB3r3JV1VrNb0OphrJtXHvbeLNIc1ebRxCGV9TvL?=
 =?us-ascii?Q?JixVb2BXBZgdra0KWnB+owIfRKTY0i9t7OZTKnxRqqfgaQzGF/7VXoDSkDAY?=
 =?us-ascii?Q?ktYew7MRS0a3aqdGBV0B60rUjMb1UwfiEaxCiGf2TrNTejy8wY9hjH5AH/77?=
 =?us-ascii?Q?IXutTwG6mmYCD8z5luH/elhS4vxNc6t37V5BO+uXQuNYF/Dnf4n4WhtaDqgZ?=
 =?us-ascii?Q?nHfhp0nLhHuA0/vo/kRxW9L2sjAk9E7RIttmZRfYhoSpeiJC1auRXfNvrqDC?=
 =?us-ascii?Q?FN3J/4AHVLaZ8D2dBfx21aN5mgVDW6Ph7SO2Mg2xKJPJqZFNBr5uvmXmAvuO?=
 =?us-ascii?Q?zx6GOazkFngcjCD06YvUeUywVAAEq2W1Rm+W74xUwplIEIwHAGSowqEe+ttD?=
 =?us-ascii?Q?/9v+DRLYKZIkbnMfHwcisACx4/tXnd6Zux3M4B6Q/p6AyW1A9JOqT+CAFyys?=
 =?us-ascii?Q?viwjOqAn+Aw656ZLbSiPfJeG+U9+CAnV90GUzzX1ujByLfkso1CHMVfBQO/0?=
 =?us-ascii?Q?ePtzYPVzZea4HtuahRm/5IxgzQa+/+kX4k7ftgIQ3isCdVHDtFd2xKjwxHSl?=
 =?us-ascii?Q?4Bhm0faSFamyzkCwJw83FWr1hKz9Nhh6sEQGqvAxKg3nEK3hW5dSAkdko0nm?=
 =?us-ascii?Q?dCs2F8m4PZky0B07sgglwJtaFALSSkPMNi3aaTSoOYcpjCH5BNRsC9hB76lQ?=
 =?us-ascii?Q?8dPuDnWC+6TP5GtuinyE5sLgDRDaKQtYpLdrDUsRrocMIJAY7f9BZ2QTTIsz?=
 =?us-ascii?Q?OfrVpJONF/qQmps5+Yr7Rg0zgBTkopG2jGUFGw64a74XV7LUpvXqw6h7ZmTG?=
 =?us-ascii?Q?6CjwB1aDE0Efgd6OFQaP1e2uKLIcLqAFh6ZL6Yoh4CELW+k7lixqOemgDQQD?=
 =?us-ascii?Q?DGgS8PLm5/rPLLqxy3Q6i8OOmkkVAvb8ljyN0JFoQFblBdiJrkrancjY/zlr?=
 =?us-ascii?Q?Jk84qfNus2HaAU7RZuBkFR9CmlupSve1uwEOl0kafkUJnOKta5zTOUr7uszJ?=
 =?us-ascii?Q?dF3qOVoeTClEFLPKNWCTfvSmTOIDOl3SiyhhCq5W/yvvpeeyuei2Ll6h7qWw?=
 =?us-ascii?Q?K7Jygga1G3KU1xNv2Owf5YnfqZ/GJegeIVP/x8kdXxtibu0omnHZCFl5gnQ+?=
 =?us-ascii?Q?r0pka2LCpb+Q2m0Sv+y/1rA4HURt4uWh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nKAAsxDTl9wYODUGXxqsPYZKnhy2shpiZvS7ndaWL71PhoBpFJcvM0BcylzV?=
 =?us-ascii?Q?qu4g/9L3soQn5rsaPcqf0aUjp1B3CXotPbxs9l1pDxXKz7LBZrp9ZKOIBrcN?=
 =?us-ascii?Q?Fb3Oq60yZ19auQPPkdjCTeV4PUu9f/bzPVcldzruoE9y38+pxL5ClejA4cR+?=
 =?us-ascii?Q?zpmtCpvvROF1ckwEfP8AjWff87s3uZFXzHKB8PXONw+ugUmj5jgJitAcFJkB?=
 =?us-ascii?Q?PbRGo17u+ut9p6kNCIcTLZSEUHsRGgqxuOuhZJD6zBUQuj4QFG6z0SPOAhmP?=
 =?us-ascii?Q?6UvZ00y2Fkl0Sg188WIO0ZJK0Ch92DLAORlcYDQqdpCzkGc23mqoAkAWvHlG?=
 =?us-ascii?Q?2SIFWj4vs9Z9u7nSjADTYBQuwOTyTz4OdFsA2UnSMn5qjb2BCu7Q+Bazc3K4?=
 =?us-ascii?Q?rebv+tzTS25GOCXJe9z85seZuTfq//iKSKpai50P666yOSL2oZ9SvZODrgfe?=
 =?us-ascii?Q?yzY/+pcGNE+jykVaKXGKbY2zmVGLgRU4s/F3AxEFhOfqJpo5LWygQ3LMKbDG?=
 =?us-ascii?Q?ql22KB3pPRlSWW3nAvLl59zlIar0u1/ljcTpYUcTB4VqEBpMiWHnSe/Xppdj?=
 =?us-ascii?Q?MqQop8XfSsBaLgC4L0+UJxyITSJqleZm2eQ7oreAbTDf8w+Lx8ivEBT+b3ks?=
 =?us-ascii?Q?+/dB6hQU/iRg9C3ij7sEpXtWhy8m7q3bSZl4XNRNGsN/O4Cpyt0ytWBdjMZs?=
 =?us-ascii?Q?LQZZHkb9hV0kgwQbqZJ5XXGFfmJ5XU1jwza17JL3OEWIVgNHxWR+aNkY4xK7?=
 =?us-ascii?Q?be3Bu8JJbioSES4FUZKCQUoH/PDkodHnoFGYqij/AjQoLTY6589xTwinYE4I?=
 =?us-ascii?Q?zEFuEUKM0bFwsKWiIevMGVoKJbj75Xl1grOcgRiiZgyBOvyUijMOg73K1uui?=
 =?us-ascii?Q?VfP6kvgcVynhrB3Rcv85pdSehBfgLq3p5tto0MmI9K8zjkzFD7wMKGHfLJJS?=
 =?us-ascii?Q?YNyyVkFk5egd0fpr9CgnkQeF3jHD1uJI1QquNobqHS0bOgTx/AIhy1u3USCC?=
 =?us-ascii?Q?MVVxFCN93TN5XMK2/RLAIISwBBHGMGfVE/aol+gFKY247/lTp4qcdkw+t3WU?=
 =?us-ascii?Q?KljyWKgCZ1cQK4doZt5tEoxrVaLa2QbhdsFofnbD217g9vqfqLBtQYh7y5lL?=
 =?us-ascii?Q?jClrvviVqopYygVykR9eAKMPm5J/+2xDa5Dzf+pA32QrktPdw/EceG7iPNta?=
 =?us-ascii?Q?6JzH3sLZoQyfWN6Yv8RDtoqr4qe8ZaUyjDhsJ4dX/jKtRdkG4OtpVjr1SYa3?=
 =?us-ascii?Q?Pbe4L6aE/jNLcx6YYFtHLVxcbBP8jYEWKdMgbpcxEQAXUtFXlqVX9Wqivkea?=
 =?us-ascii?Q?0NMKKzbJq71MJo51vQifKmECxJEyJHj0dT3pyDMTaL4BX6oOqaFNuRqWc61Q?=
 =?us-ascii?Q?t4Z8Gsj/ZQnf8je7Ngd4EW5+v1Vxhiib1s7DJwWU1tb6XZK199SBG5sxOl7J?=
 =?us-ascii?Q?7FLhrFAcyDT/pn+Jo6r5DUYzD9yyPxeBCwWohcvy/yymBc4PDv9++HCbz2I5?=
 =?us-ascii?Q?q4ZU50cXNoQbg3WZK48Fk2t/R4PbFmrHa9aYCYeY+nd6KQw1KEzKXybnCI6h?=
 =?us-ascii?Q?I5eJSdiwstlI22PKVvLf/r4pnUIHkIuEJy5MROeIERLmgZ5AFM6ltPWanPOh?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b6ee8d-7be7-4305-530a-08dd9e29b84b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 20:53:38.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hux0RriJiy/7XFqOKfxAVUdt6NLSJRARo5io2qYnD0q3bCBmpy2v9OSUPDgAUZk0Ij6Q2AstmcY9wr9CeZ4ScrAoKx7xmChkqryjX6vARf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com

On Thu, May 22, 2025 at 08:15:06PM -0700, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl-events.sh and cxl-poison.sh require a kernel with CONFIG_TRACING
> enabled and currently report a FAIL when /sys/kernel/tracing is
> missing. Update these tests to report a SKIP along with a message
> stating the requirement. This allows the tests to run cleanly on
> systems without TRACING enabled and gives users the info needed to
> enable TRACING for testing.

Applied to pending branch:
https://github.com/pmem/ndctl/tree/pending


> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> Noticed this behavior in Itaru's test results:
> https://lore.kernel.org/linux-cxl/FD4183E1-162E-4790-B865-E50F20249A74@linux.dev/
> 
>  test/cxl-events.sh | 1 +
>  test/cxl-poison.sh | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index c216d6aa9148..7326eb7447ee 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -13,6 +13,7 @@ num_info_expected=3
>  rc=77
>  
>  set -ex
> +[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
>  
>  trap 'err $LINENO' ERR
>  
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 2caf092db460..6ed890bc666c 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -7,6 +7,7 @@
>  rc=77
>  
>  set -ex
> +[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
>  
>  trap 'err $LINENO' ERR
>  
> -- 
> 2.37.3
> 
