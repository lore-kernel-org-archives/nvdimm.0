Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291C237180
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780363114; cv=fail; b=jDSDln2R9kmj5s5BEd0TDeSFZM/kwzIwvlhjLyxMTKYeJ5SkNoTC9ycTAN+vgUqr5CetzcuBiYKMPZ0oMhrGfDTzhFX/g0ki5t2fjFko2kLHBM1KxnUGXC0n4qDvg8lc/AsJjO71XrNP9DX5rBc+uJLNVcItRsakyJyvrPn/eus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780363114; c=relaxed/simple;
	bh=L/nK9V3PTwaTAYnVhOcd8oB9CEUJMl0Em105agIKmHI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OwLqWZniP89FLRYcXQGJ6Nod9MXjWvdceCJJhBseBRbLSVTK1Pv2k/DHyaWVsl9NFdBxfQ8GOb+KEpb61y4FIg5sZ1Zlp+t7Ctm5bNgoiV9D/EwW4gVjF6NweWjg3G7tkWMp+q0nPutBNzSQoauZfYqLeomin5s1dnUU6f+ACIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gNBrD6T1; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gNBrD6T1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780363112; x=1811899112;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=L/nK9V3PTwaTAYnVhOcd8oB9CEUJMl0Em105agIKmHI=;
  b=gNBrD6T1p9z0Gq9H0J+Uj3rAoyNqnvtp/qG4L4sRV7fU89zgKhPtDm6e
   lgpUJcr2iVS59ZF9XFBM6PxioJ9WW58BYsq4Oh7nibknoHF9T5JKj1FxZ
   tFGyauqeazBmZoY0CxFAwhcQnbEGQ8tsVjQURkwIeKmRbuRm6APqn1iSS
   6wHIY27w0SVbvT6U/AAJXzOSsXPQRXwB6gX4uWeoSgKso0a/IVYhoORoC
   3Wqvx6WYJ7jZ72OeL0cbDRQxjjQd62bachDN3ToQOoiiJgYB232VgprR8
   CTeyF4kTyb/HzXyuS759fhvOrju/8dIF7qylNrYBWhFtdmDdHIxgLgYRr
   Q==;
X-CSE-ConnectionGUID: dj7HYswtSvKz5M00/q8XcA==
X-CSE-MsgGUID: b4PRgmKSRXOANTCfkqm7HA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="91819776"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="91819776"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:18:31 -0700
X-CSE-ConnectionGUID: GjSW1MJLRi6T8588N0tpfw==
X-CSE-MsgGUID: nQO0uAZhRnCw9TsrW7mWjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="274009187"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:18:30 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:18:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 18:18:29 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.41)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfKUq8IeqFGG/ovMd6MTkHaxv0xcVidz7ohnkr5j65wi/NadDeFyXMI0rKhAjxM8TJxMNcKF76ZxZhQRP0CmBVjFZuR/AsbMEKmmLyznQ6+yvkfxP0DZSfpXVpWydCcgnDwwN2p+cUgq3WFw08w3Yx2/BFapAf7UBxkrZ2VtO8Cju9CLXcITp7yqShuaWDC4IT0gNoN3LIDI3wcXZB+4CTLIh/GBhP61phZoi0Q07hCFyPDrP8y5nnyn1fcZv+oSpLQtj0ECfw4acWhx6hT8RwX59a8QHatDwrWPWmXAojcfXibqU5+pPvcA9MSIqT4NIozgLAJHekdxza4GAFoYuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/UKRdP6iHdEnpq4j3DTyuXx+FDEVmA0rezs+8vK8V0=;
 b=IZcxCzDbOn/ymsiWZRxlxf18Tguo+IIdzpZ6obOMIixdHB/KQ6ra/+7jkVR4DDfN1ypJ7xG8V4JurGM0kpgjDCpvkyoz/EQsyj6pyPDmlBW4RZTVwTB0KJPU8NVnzGRHyA+/LSKk1QWfR1oFRYiiOHHja8UyxpT2m17xsXfF7rnlC1LnEoWP3vYqO70lAsGISIGijc9ieDPZJ0fJxY9Sqbz1QQP8Kv+G2rPV+VPXC3PtDpCBzbWbKXTdNVN1jIv7WwFBAAIOql/U+yuwbuVyLNmU/NCUOTjOrWPom87k+bAvLlpjnpX2mxGRxL73x4UuzGvR1JgZtV4VojNNMiEVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB7754.namprd11.prod.outlook.com (2603:10b6:208:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:18:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Tue, 2 Jun 2026
 01:18:25 +0000
Date: Mon, 1 Jun 2026 18:18:21 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
CC: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: nvdimm: Include maintainer profile
Message-ID: <ah4vXbPHrJhXKsLw@aschofie-mobl2.lan>
References: <20260518104306.39289-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260518104306.39289-2-krzysztof.kozlowski@oss.qualcomm.com>
X-ClientProxiedBy: MW4PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:303:b4::7) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d59e1c-8420-4703-db6b-08dec044d85b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: Hvismjn3Oeg0eQvpfojCed7P+j1hr4kj+/ctHkiScY93VEmdY32NPgtdhlnGWfT17pqhufu2WMfPWzLBnL4fchNwkZQ4HiScBb002RHv1VgJHquRkXr4z3+cC+vP3nFAiXqveMS23ZokZVK00IHkcYQl59GaeK7lg38bOzmO5rzotN2cnzEy0jwMFTaKtz2Cr91UmoqdlGozwkQTddIyo4y9dyPkdV3+KvUX10MSM7TUsW8bScW7O6kOLHO/60BF5nzNLNk+Kcfw73rYce2Mn2xqxldKpgFgvN5jkM77DHJSGvwVSTjPzn/XSTLrwC1pNWapIMmG3da0uU6swautoJ9FpX3Nvpa71vk6BpNhtvWsHDil7jlyU6kTFXs9BEsTnnxITyY4eI4fDiXdRODmmcPtgFOIKO5NSweGBl+S1IQY5Lsmkd/2QHosvmgEBhMArOMoaq5PDed3uQ/eImxpUMCf63jGQksX15ErFaOll7jb3rD37r11Y5FeRS9DTxzjHUIqfQRSDCpmTRt6KvQAmOaf6tV7HyJ2Azelv36HYRcTSrCe7JvP7MZlPEidw30wJGJ2twkA5f5vZEb9ZvcWx3Xg59xtp5Wh2GmUtjCVM2tVTLBHFXobUTrx0/8uRzXOsZEVad/jIWmVuI0OZpwAZgVwFeuBtWKJrwjeeolu02WiYi5bHFe1FVJPq7BiBzBE7d7jTVNyVeN6oVnaxWjHYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJyiGTRA+WdSOiSRndBJL8Rl0wjuoJVGruNLl3VZEqcQBVC6eAJO2nLiKube?=
 =?us-ascii?Q?HuJG0PjZV3UzRMoH7v1QfgF2mipM/5f2i410Z+KQ1MHYydJCkgNMart59zq3?=
 =?us-ascii?Q?LHYIQmyCk3HGlrrrfygszw51Rg5PgBLz7qX3PGt842PMUldKcsj3xwJBhwkZ?=
 =?us-ascii?Q?5l2cLwN7aNTbbN0Te5v08Si1vDTU+F1TtZzFX40IdEgucXCMc4r/uuNOOucP?=
 =?us-ascii?Q?8cqmXS81RCWYR4E2hw3mia+mwXvXMtbbuRLRftqBwlMolPyDYScEzeQZUqEV?=
 =?us-ascii?Q?o5hjbq56AMnF1q9YWiDrBiKDr4L6CtehVAJKv+a9cQE6I2oqkNqvbOrlJwDi?=
 =?us-ascii?Q?vtBwj0PrPCFUomyk5w4rw7IvL2yMG+vnPWvZotFyDz6/4kR4EMCFtWxyCtYB?=
 =?us-ascii?Q?pG6rVDLWBeSF79SMRecqR80MxTkLVA4kpcmaSR8zDMlChpFCZcsCxHOW1hwW?=
 =?us-ascii?Q?OvjPwgUjhDaiiZ4Rq1vmQZVguq29Lzl0+PNFSjmachTT96TwRvk+vvVV5Pny?=
 =?us-ascii?Q?sjVajO3dzkVqwDqXgpzernk9qchxZJWSXjuFF3XvCA5WATY/x123ENKTsBlX?=
 =?us-ascii?Q?kBdgBg/Lwmh2O/oTFlEA8dSzc+A3THEaKkyrb3Tf0NFPTYCMQrUja9dFrGSK?=
 =?us-ascii?Q?ckyqHeJZ7cm85rtCcU1PaUzc8xQ9jilOSURI0U3BVlaSBB/vaBWm98U84z4E?=
 =?us-ascii?Q?Pcm3nGFFOUUojwi5PkVixarWL6TXrBqWrFYeh0bhAv3m63uRnFgd2B5JsQlq?=
 =?us-ascii?Q?d8BTXdWZu72dK4yd4x/afQrpoNDSLOV31Y0ZR7ZS4RK8O+U7+72dUARCXkTl?=
 =?us-ascii?Q?yFHwBf/ToX6VGszTd41/+LODMSChXtZ4Btd/osUnGjnTWMuGl3vqN18YdAoz?=
 =?us-ascii?Q?xaBTdzH525CXMtYwPvQjggWrbfk+QMPQfmvMO72TpOk28H/FeM1w+X8fJPdG?=
 =?us-ascii?Q?otoQ4xe7BaIYquWfBZixcXMMMw191LIAm7qnyO13qOcZNqAYLc/mdPYNYt3V?=
 =?us-ascii?Q?eTM6XqxwI04ocZHTUdZUqYkPS/0S0KWaFB38Eh7WDL9YRgVfTh6vIC6SmhaE?=
 =?us-ascii?Q?5ReU3wPCy5e9/B/GxDPDXjus/frvNS2T4LIUGKmZhXRx36Ih4j0Wfov31RO4?=
 =?us-ascii?Q?dOdn+ON19hLbIUrbDtpMb6Rb2JBRjRD1R7t7KQ4MsUUKznu48qt+ZJfkm6mM?=
 =?us-ascii?Q?hKe1KDDmDxkLlLbPRoIrCSfg3uk87FkcET7sRp+oKkPP1WgQY1XujxoJ/8RN?=
 =?us-ascii?Q?LtPO3N6d17aGRTnM/LslXWS4dtKAX0hzfHoheKIdOCKwZSRAW6sqqjQGToRp?=
 =?us-ascii?Q?F+r9QWbQp5AA9huWQ+wkiMMylkRsEWxOCvn4fLJdYOC6jRJxcB0I2oh35hkZ?=
 =?us-ascii?Q?7UncOgSerwojYNtfmGXaQPJPse9LEpsF/YXuGEhuj5EyhfX+elzT442FKwUz?=
 =?us-ascii?Q?GKBxkrsxt9B4PtR8FeZRyVjarrj9sya2Egw6UtogImIGfCsR4u3YdCdf2Fsf?=
 =?us-ascii?Q?KpWEjysDbKq/lxa2IkVQBesMg5a5tZQCgy8V6ITZLQ3j4sKhGlG7G7RYh0FI?=
 =?us-ascii?Q?2cdo08Sc5sNcTzbcVT8MVFOFNtnTImtOIVlfx91/OOm7cXBLGRHeM9ccNplW?=
 =?us-ascii?Q?OzpXv4TLYvc46mjgp77I7yIMk97aigz/ztYuzb4Hy0q8flKqkWjwGburM2R8?=
 =?us-ascii?Q?fcAr0YJCMEOsevn26lqLqhrO7muMOPh3Z8n3FqTuMho0lZssnlBg5oC2WnR4?=
 =?us-ascii?Q?r+h/MOJy4Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: U9tj/vVepe617ak9uL+2p1qh1cnN0V4ce2meJBZs6dSly1bxIwEaAhAMVBYCu/yBwc5MhQ3WwLK12kmF6B4kDoXk17QNglWAt7zydgFji/cEzd8sGQ4LRdXiAIhlv/v1OoSO648mzTCCPP0GfO+KadxJMV2FrqYYppw34vQ7OKdKTGoryDUWBOhOQ3ICIuZrUYLED0exoBrGoIL7yil1A5wDVfc8D0E2p9m4jixSNQ9G33QcGCneRQZvAfK+jOoyQ3GE/ursfKEIeoNAeBT7SaYxeJ0T7x3lrSTlHvJ/HiG5qDUKCihEW9SOeIEnvZWi9McUdkGpAfEJmUfHYivDDA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d59e1c-8420-4703-db6b-08dec044d85b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:18:25.6030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MVp+vCSqkRD+uD2/VQE0eujyVw1At+wBJbHwBArACPPd+UU/iam1H9sE4/JOABRZvZc2fSg6kYr/F4U3l8EDRdh8pJUK0bhi5KhkjWYltvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7754
X-OriginatorOrg: intel.com

On Mon, May 18, 2026 at 12:43:07PM +0200, Krzysztof Kozlowski wrote:
> No dedicated NVDIMM maintainers are returned by get_maintainers.pl for
> the subsystem maintainer profile, thus patches changing that file miss
> the actual owners of the file.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Thanks!

Applied to nvdimm/nvdimm.git (libnvdimm-for-next)
https://git.kernel.org/nvdimm/nvdimm/c/86e411b6ec27

> 
