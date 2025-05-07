Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4028253F15
	for <nvdimm@lists.linux.dev>; Wed,  7 May 2025 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654806; cv=fail; b=FPNVdYx/HjZoMhwNexMUqL+X0AoiEjLdBa+sEjyaS750pzdu7IWoaPXyF9hPV163+5xpHP/3poERCimJuRGwC1GE8m+3K8nT1HAkt19YR2VpaVuNnMADirBbVOoGb6ldYDoX166gPnEDld+dPmsZVQAgCD9khXGfx283c8TUr7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654806; c=relaxed/simple;
	bh=JPzRuGnhD84z37055Z0mSD3fCOK2Bb/YG+FjtNQF2Ng=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XGKE3SzpyKYvll5ZYPKwiSji0cYmHD6po8rqN6Q7NRajGwKYHuL6w4nB3aIf98D5A2Onbu5vZnQ1c6JsCF/CMaJTENS4+j+TlHb7NL486GM7NVuAE0hJOKLVLL7WWeLRqSfIt7mfyLhGhLshsGF/xZNnovYCQz2p7BEKVh6/YV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ish21Uwh; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ish21Uwh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746654805; x=1778190805;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JPzRuGnhD84z37055Z0mSD3fCOK2Bb/YG+FjtNQF2Ng=;
  b=Ish21UwhuOkCmRsH352krEqLN0JEkH45WCpDLt+D2aIa4P1Bndswco7r
   cJKzgR/ykhiW/O0Mo30W4/jFub5xrJReZHy3mdRJ2NQxIekP5cX3+aWmt
   GCLOYT+7IsEFafdXprODr4XkUnQJ8Iu3HmcpASqFAj1ySEwY+PQr4ULKq
   0baoKcHMgwcELK9G/xtXrLFvesWE7p2cG+4xeZ+v6fM3r1709erewoWx+
   xVJI0buWYx5uZLR57MlZGXdwKMGXka9sCts1lkAYj+EMWiF1R32eDC0We
   RsMTp1cAZSQ0N3SDRLyRemBdW6I+P4tVI9fyygYyEFCff1Le7eGzDOBXW
   A==;
X-CSE-ConnectionGUID: kpfRDalFQty4X4ohHUCkqw==
X-CSE-MsgGUID: IFBuZNqIQ1aqtVsQGuqGOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48494185"
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="48494185"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 14:53:25 -0700
X-CSE-ConnectionGUID: mlFtUhBAQJiZmSHUM3ijsQ==
X-CSE-MsgGUID: FhjifJ1VSCS2ZnLsBO8Grg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="167146808"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 14:53:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 14:53:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 14:53:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 14:53:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJdDeI5Lfccg427o3Qyw/GFJxnlJCPyZX32WQynEDTwIzrn7SfWI8VVmFcDvl2zHVbHY57dvYOwqmjfPnIU72WlrBwEsmY87v7XeplMZWCqrvMcIptfOdu18pDc2ThCXeY7xu0ca7FpaqpPT8Jd3ZlRg4d4KUxyLQAQVGvyeXUgDd7ZppjdGovfyjR5Be2cfqVhSEgdezPFnqPzpm4kYfeQOZu8mrUXRSlxHTdC8JQ2s5WFlSx8XJewBm/L/n3JpWQTtuQ5NezJ4KjIst7arNfChmz9uRwBTbM9djqxL3h3eoOKtRhWHXNEOvQPLNmSsiqWfQM67A8EeTWI4V8y4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKyDK0FVIXIH1slZabvH5wCLo9LeUweGWx0XNW8vwfI=;
 b=cxzCuupPgr0wfCXgXuzj0uz74mppnZo8cBAhxigoWki4BJIfcWCJG1skfMRQYdKyTxwFHkUsIMrSmjB8Vm4WXrjP0YTzfEJGlaLsYsORCcb9sA6uKBH42bDFgBFmvagABK3hO+SFW2J/2/RC5pDrHoHZ+ChBMCb+a7tF2Z9RN2+FKs1UtwShYPe50+3lObT4ZXQueCwggmdFrSVKo74ZtsWNxI6lDCBSnAcJ5q/69ev8ZzwQsfh4TRYRitzoqA+aD3K4iM0JEhyEKy6/30ZftFOVMe8v0LzsGj6tGb+TsbKmcXqeCDzgMggBzIJ4BsLF2JLHkEKa6qxAJUIGng5XxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7193.namprd11.prod.outlook.com (2603:10b6:930:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 21:52:39 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8722.020; Wed, 7 May 2025
 21:52:39 +0000
Date: Wed, 7 May 2025 14:52:37 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: <marc.herbert@linux.intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: Marc Herbert <marc.herbert@linux.intel.com>
Subject: Re: [PATCH] test/meson.build: add missing
 'CXL=@0@'.format(cxl_tool.full_path()),
Message-ID: <681bd6258db31_27eca029426@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250507161547.204216-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507161547.204216-1-marc.herbert@linux.intel.com>
X-ClientProxiedBy: MW4PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:303:b7::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb1f5d0-c08d-460f-cd53-08dd8db17ca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hgmmsvONPz9FpS4AEMYqXcoG6oQqKlMkmtT59y8O6BYDJSmRR7qlSC4J5PHe?=
 =?us-ascii?Q?0RXcvM9oZjl8Ti1Rr5BQYeLKSAXyyGD6TZUJD7jQOg44lxjldN9RHrzR4W24?=
 =?us-ascii?Q?KemI5hJ3I+HBo1LHKI4kPB0FqEUZrcONp7QSSlgcrxlNGIBXmQICHvaoFrgN?=
 =?us-ascii?Q?xQ3rX1fFseUbHLfS7b4PK5wcIRnAFGg1wcEDh6Nrk6cWEekaYbkLNzRm/b5O?=
 =?us-ascii?Q?OfaajBZL7/Q7e7e0HWXp2IIwuftoKCufCdQaAflTx3SmYHeSXJ/7Db2GCXj2?=
 =?us-ascii?Q?NelAI0USx0G1WysGcB8WSZy4Ddcsenmdpk3RZ+vqZEb4+BSFZMCDgH70Q3sS?=
 =?us-ascii?Q?HSrT45YcwlKrM15sezrvGSiCGBNHu7qQ7F3t8wJ0a8573JNxB31OLp75Up0M?=
 =?us-ascii?Q?TX3jO+kKl7VOyUr+5uENc6rCPhX65dqPRFp/Dw9BMksF+OhhkdLYLg5sJeKp?=
 =?us-ascii?Q?1HDzCROqky0c1w9tJu2Omjyvz/1Ortv8cNa0HvSEHakwl3BGwsDYedU1BeJ7?=
 =?us-ascii?Q?pa8yYjG0MpMd3nkByROQ3cmnWYogJo0yWDl14x/bw1h2NI4BfJthrY4DP5xF?=
 =?us-ascii?Q?uOXvKZTVuoe9dSPQE0v8JGugsDVGzLvP9J3v99JARDYsabduUTLQZ2hH8ChL?=
 =?us-ascii?Q?BsBjkT6Er6H/gJVLzkNtegQofM4J43DyfrT7e6EtoawX4nWfeDwRLzQDp0us?=
 =?us-ascii?Q?CFzGL91kaZBcbaClgmyuS6IeAXb92mbDFZb53uBfFBD4i58E4VnvRZ/qchzI?=
 =?us-ascii?Q?llr4yoL/Gsh7oIKtl32zOFK+Y8HkQx6HomLeOV4OaN0k5l2gC5/03nsjP/au?=
 =?us-ascii?Q?80adzgiUAc8Au6T1hKORQf2UfvYuNUsqbMJ+x33XA1nMSCjG4/ATQzdQLUVm?=
 =?us-ascii?Q?IBoPyxjDIB83sKUgFBo87nqniHP8lZQgnNoBiOyPIIu1ulvMyE1eqMKNIM3P?=
 =?us-ascii?Q?hkwhQcn43dU8xZ32Vgqy/pVwVTaLbN2vnd1HyWgm88TdmJcayhlXyWjI7b7K?=
 =?us-ascii?Q?oIEgALsVMFm6X3lL3Rqkxh8LyF9+wscs1ZP6wgjzlmFjdC3NaLR5rZEGjzyW?=
 =?us-ascii?Q?pckzNUaMph+/eQ7KD+pea5K3MRDJg/bMnykiGNw6TJnf6tvkltMOlciOWG+i?=
 =?us-ascii?Q?MyqbqIimgVp3MC8el/aIgPpLuXaR42btcchJ+Vj5OoHFqkcwbH8XCIengHQ6?=
 =?us-ascii?Q?Yh129E24aq2Zrd7eK7LWCGHEB+v7e8+XjZoht4GftcVbtM0YwPV3X8XMSHh+?=
 =?us-ascii?Q?vEjqEOhDCwafWh6zgOuWqA9iDKtni+ekTi825oZjOY1bNRDTIZ9RXK9qiB1B?=
 =?us-ascii?Q?2ta3PVaxcHg2tib+s+ayo17z3zuVxCzmoIzkzYVvC0qrgYiCr+I+BnVR9Vjp?=
 =?us-ascii?Q?B086vwBCEY0gpujmAwox4RJVJpVncxe7X4SM6W2bzz5Q1LaP7XCTwFTRHI13?=
 =?us-ascii?Q?TWUbRt96k6g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cEM9CxkXdbUBkTjVoxUDg6bNjCQPL7StvlJuJtVWxih7wxE6LBJwgTeBdT11?=
 =?us-ascii?Q?lmShCR711u+sySf2OBJLtjzfJeeiw6JlcCdFpKuVnNslLxUNqORsjjakDizH?=
 =?us-ascii?Q?N5dG4kRTtK1sv2+hYda81R3nXs6/pAuuLovZSfeLGAmxjowxgngdVs+fot+V?=
 =?us-ascii?Q?xohD+DBAJ6gdY7sHxXjk2dUnv7K6Hu1AgFGK9FxGsXzp697LVplYPTmO/vL4?=
 =?us-ascii?Q?k6m4s285rlA4ldnfzzGetHRQ29lyX3xRBM4w4B+vpw3sEYpoKx1HasDAHmBO?=
 =?us-ascii?Q?CJTm/uis2ju2TXyW68/u0U5j/Q2+KjfbGIQXpH3j+2DmCsI9teWxa6p+t7Q6?=
 =?us-ascii?Q?RxzAmcgnjJ33uyg7mWUtEMiZ5gnDBmLd9O/R4x8tFP+MmdF7saHD/3gkoOOu?=
 =?us-ascii?Q?pdJxd9dYAlAJLPl3KcZht0ZqJtBnPEHRyXorJFLA6glqAw3XaXO4XTZENYHB?=
 =?us-ascii?Q?PgA0IfMwA4OabcNwBifUFJt21WwNXZfo9P611ofGfLBvnyY19ZmA35jvygKR?=
 =?us-ascii?Q?L2SFXI0FhCm60/lv7n6so4bUyqrBWTU3DT+I6VBAsOBITdQDviq8YlIJCATu?=
 =?us-ascii?Q?DHJUdOpP9qPWgm1XqF2h96iYO1PtoGAYcN7SlzlKFas0ZETX9xWq1imjxIx8?=
 =?us-ascii?Q?M4qyTuryj54Dm3nk6CH1cTKC/PZIGQZ6NgfIy3sa8llovhogxaukt4Q4hATH?=
 =?us-ascii?Q?vmXlAVSymfbFLSp4R/aaup0qMK/JjnUAzG7rzPL/S0DhC4Hm7axoLUCNK8KC?=
 =?us-ascii?Q?O5zc/HdLZhn7jGJ9jhpyRroEaq0DsDtXapvOvxPAiY6JPp941AIx6hpTQrZ/?=
 =?us-ascii?Q?jQufjAmPeyQyzfhkIXrVbhGg4jz1VLJiO9ovPqSzVGq78DVpczcZfsUbwu/T?=
 =?us-ascii?Q?rjp6DXtv3B+bx2iNRs4yd6N2nia0vHFQehu2PPqGz+uYYfxahxXjJgEV6L2r?=
 =?us-ascii?Q?ACRNzNc+IF6d1zTYkf/zNBZ61BICO7R2kOLeXSST4dzOgj3kNfJI+t/gmQum?=
 =?us-ascii?Q?fnJbD6uEkPp/UHmIceHIx72cb6bH8jAZfObV7JIklZ5XL1ezn91elcBZOGbb?=
 =?us-ascii?Q?ERPolWOFnmG3SUgq02SEGT5QjuMGF9pOd5JPDAjSxljmDioo5fogWSmwWC/3?=
 =?us-ascii?Q?UHVHyWAeF2CbPI8h1sx3kVANZHDPs8x+V7yRvOUjzblYYtOo/NwEFjY8mdxK?=
 =?us-ascii?Q?gCR+HP6Wb/dwkrMf6jJf0CelrJwTH7gtQm6QwZBY9y1iZNPBXzwnhkmyR0Bn?=
 =?us-ascii?Q?MpmzdSK4cPRzUBMoTh+0y0hF9eJ4y/dDAim5GD+wk3V8df7JrX6rFrXnsqwW?=
 =?us-ascii?Q?BqTDzUILj4k2uqSlshWkCPS0fPtTTCgy14mO6HMczEcuI6/KqkiCyFfMR/ur?=
 =?us-ascii?Q?An+D/TgEKmUC4MgJTFkSxtuU6alism5SGxq5kqcKV2GAgLPcqmQ53L0ODALN?=
 =?us-ascii?Q?yRRPTYl1V2BE1VR7U/Zffeb6OfhRZVeG2eTWRoHny4di6AjQLyr0UyIBITQ4?=
 =?us-ascii?Q?N4hOSZeUHvYXZcZpJAwskLhFSLcNjaDimoj/PtzPuLoWLGOFDOKHkCKm+bxe?=
 =?us-ascii?Q?/MCI8lWyIjP9zB8Wjsx3baWov2ABtYcxntRSVZP/pJtM55dZbpzUPsJtV6uT?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb1f5d0-c08d-460f-cd53-08dd8db17ca7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 21:52:39.7551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPifklIq+kGbgp2BkTYhOdizKys+pl5kVq0Nv9V0pcTOIGKbS7yH/fW25N763vfmCZx3myKTRv8u/6MVqEi+dwYQQ2M3wbIq/YIFmMk0oeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7193
X-OriginatorOrg: intel.com

marc.herbert@ wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This fixes the ability to copy and paste the helpful meson output when a
> test fails, in order to re-run a failing test directly outside meson and
> from any current directory.
> 
> meson never had that problem because it always switches to a constant
> directory before running the tests.
> 
> Fixes commit ef85ab79e7a4 ("cxl/test: Add topology enumeration and
> hotplug test") which added the (failing) search for the cxl binary.

Lets just use typical Fixes: trailers i.e.:

Fixes: ef85ab79e7a4 ("cxl/test: Add topology enumeration and hotplug test")

Alison can likely make that change on applying?

Other than that:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
