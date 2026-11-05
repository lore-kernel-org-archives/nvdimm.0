Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793920882;
	b=W1cJAt61yDryrd6LPDia1tezHM2tMTW2yes0KA7h6ZSzZETj4GPYRSIBw7OUEBeawKro
	 AAHD1ipeGJROILX+AKIAnAQY+Ynhp7gibqFTZYC6udiTKuM4Gbd/Vn8MIFQWQuMs0BPlm
	 hJhkvBAWW0XNv28Buq+m6I3j5gkraWXFf9DoLU4sM9YlcMAdtst3K0zoBxaO0h1E424KQ
	 bnS/NFIlh/3fKC9uEh2UOrgJQGyhRl9pDj2letAHmeIuzHM1IIHPjHCjoBnu2MYbaIfjY
	 Snq040Qd4V4FxNYuYsaD6HuH5sDjBWBhrb/MGLgo3ygGpoZyMCksBceoVRf95tv22ug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793920882;
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
	bh=W/XWEMZWTdmbkYRjAebnNLY2MXXeqsOIvblzi61l/7s=;
	b=lFb3YFFxCpI/fOJBIbZ+sH52oJjcFwkQHiBOFTpwIF530un1qO23ecPAqX6rZOvdYJI0
	 mZGX+BfioGvW6ekjDh49E9Fu1v/+zAPhFM1PnpDcd+HJV22HbUf0r3XdA8jTgeCsS4AfP
	 JrMHwuIS7tnGkFKSvnR/PEb0U3uiWgJN5z6eCT5piINeBP1OZtinDxcU6oSqSEqZcZm3o
	 dfg/tETxg+RqLDOgaBWf1AOx1o+R/Kz9u2N1UU3NCwd60pm2gD+605MTIZxNtbYuOBMAy
	 AHIQO9qXeCI8AzFshoFjgezc2y2UVOLl5CXaugIfOSkPTd38BCACQJqExhs1LZ27tbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PLYsqirA;
	arc=fail smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E22606A32C
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 23:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56E22606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PLYsqirA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793920882; x=1825456882;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5ey9PDeQUX7VhePPJUmEObV2Cn39TTzqlEkFEvwbF7E=;
  b=PLYsqirA1m5eVDGf3TCjSfVQMKfsQtqx/jxGHdNIbH/zzK/WrFE8Hry/
   4d4U40urKQeytH+uczbH4Vd0lmL1hr2drNFNpJIoSnVriC1gJmYrGVE8N
   AFPsWG5aM4ykhkdw+PIROe3G9yXgpcSExwMg7iGg4rCR0yhpnpbJzUKv6
   5yoASkX3AVoBBDRtZrKlui2FqVlC3HDVpA9ZPGwKTUB6d70ir0kBEdQ05
   qDCvvOYYfSfm4I1DqZg/9DZSj0GxYmE+JCTdkY1LzfduZdFxJZ/16p7zr
   QAIZHSzh5tfapt40IGI5hlve+MRd8RXV96IFEJdKtq1AHtzxwONIn8uwm
   g==;
X-CSE-ConnectionGUID: JYETpVChSIaWuY9DFiVjZg==
X-CSE-MsgGUID: qn1DUSHgRFqOxGcVapvbmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2831423"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2831423"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 15:21:21 -0800
X-CSE-ConnectionGUID: qQ/8i+LdTDeo1UlRgPBR2A==
X-CSE-MsgGUID: 4D9FYNGJRVKX4uX/kyLYGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7463926"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 15:21:21 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 15:21:20 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 15:21:20 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.21) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 15:21:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xFnx84CwvSzI3pFz2y1jyxUiyuRL0A1jZGZja1Yu7ZJijwMRnBBP3bbLPx/TU8H4ABRnff+fALeoSYPYHus/ZMv3/BgsBWAqM0cKGAX6BYxwQpZQ/X6Q8NXp0EOfYo9bXyAWbKWNI9W9UbO2DmdD+r0CNiS8RqPe2L422b5xdgrFtyQNUhHuU91PaAnoyNZJUDnGWmI7Hwsruyu4e+EJ1Ab2kyXyyhdzO/ZWFtIrcJP4vDfFR6tqE67cnEuUIp1/WHWhkXUmcjwB0jUBPq3htrFkoGxgzsjF0XFsY3gP+kqmwSeuawTLEe8VSmLKlLGtiivln3dUbBHCWCnj/k7N+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/XWEMZWTdmbkYRjAebnNLY2MXXeqsOIvblzi61l/7s=;
 b=JluOPWoM6+Ema0ft1XLSaOKXI5UuNEmiUCg11eLBZchFNhe51w6psfphNXks/1sbrY6XAKH/PaL2Ug+wotQlFRee+WSWPrlu7F4ydR1ileLdUO29t5HXizc0nlw7URuHBg297y/CHuNmrin3czFA8uppHXCNTUCYylw9EI3ry6ie6JsEiPVD6o9jA8+F9JZaQfKV6R9Ux09Ty95+CJatcsqWH1Nbf+YNtBGexxle1eNOytZr+5wWH6ocWTITUfuMTGbJC9ryuWoMgkc1gLemxkLN5Z/UelUlreDXN3dySwa1PxNzjUrmL/Ft7r/osl+LR/qO8ff3cCEiyUmJAIgfIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA4PR11MB9011.namprd11.prod.outlook.com (2603:10b6:208:56b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 23:21:17 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 23:21:17 +0000
Date: Thu, 5 Nov 2026 15:21:13 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <mdshahid03@gmail.com>
CC: <vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <iweiny@kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvdimm/pmem: Fix disk resource cleanup on initialization
 failure
Message-ID: <au0PabL2q2640uWI@aschofie-mobl2.lan>
References: <20261104161825.314835-1-mdshahid03@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261104161825.314835-1-mdshahid03@gmail.com>
X-ClientProxiedBy: MW4P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA4PR11MB9011:EE_
X-MS-Office365-Filtering-Correlation-Id: 84802ca6-d8b5-4287-89c4-08df3b937df3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|22082099003|56012099006|18002099003|261102123227099003|261021121427099003|261021123027099003|261022105027099003|261009223027099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info: qmcn04kW7uSxs20fKxGpNwqtmiM9tOdLm2cG7kaF7lAs2DF7lYmgiYUhCXtcJBiR4hmScWbtemjni52TIQpLj39p/KTbRF9e5GcKh05zf7FmX3MnBSXsMw8W41AIIJM96f9UHkUQoqcZgPShNSldRwJ7KwN5Le2UHaO4ezViEnliC4RtTj3YeC0Pauaw/ShCtPb9WRWZxXUZ53NCM3eDOIAzwE0+MfZ+M4Y+jVF7elJNroV5gp4uNGslwXxF98I4fHGKA4m/iHxHosNUfzC1CYFYxaVrwnaSP6Q8Pg5Gm2gCODwRLEiutCGK428NGSkPaGwSZhSVJSLeo/YYXDLZzr62Jq+2Vhh26PFUkKOIRYmvo2rcNZE58fmXqPTAMvzyh54JiZDye2R0HDl2pUnPjjb5A9hcndf4OsqhHSCGoJdCKL88qy5QVx/r/QUASo1x2JcOYHFoPvrbrh5jyu/qM8ae24up+M9hqpel9lbE1bg4py4uwX2MUr1K4z7/ONlcQw45iiEMyb4wzQmjxYOO1VgtHoI8bpU0DuqA7P+T6fTHQKcxxtUF9pAlSMeVbR5bbWI9Lz8yf9wnf6AcNcXvGO9q3SGArjaWwmI8UYR9HjJgmBrEpoqCw0D4ht2wjSS3tTvbr3xeA39dgqOcZUlpG6pRcMICRbzzrRcPsT4Iyec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(22082099003)(56012099006)(18002099003)(261102123227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jmp4g0stjyqJOEQGnX+kOlA/ekTq5VAWfx2wOu+UHD0pd/eFkgZc1appVMD0?=
 =?us-ascii?Q?aNOLHKlS4+EnQn+OdCnaA0qCxkGwE8S9Qwxeosl4hkAPrFq5srMkfdqtJqAF?=
 =?us-ascii?Q?hojTfKYU0jHXOmGDQYw+zxVxO+umiYLmDaILaRfljvcUjN/KZ4pC2ltMzjwI?=
 =?us-ascii?Q?OqGk8C+iH9JNtvy5Z0MeCc8qAwumhVrsxoSjYyvWrkuu2a5t37Oe3lRYMtfl?=
 =?us-ascii?Q?yrWsPjXveiKT0mfhAZbbgHweB5Y5Ku7fG7PXNLCd77nmcJJMWXSDobVHRGcC?=
 =?us-ascii?Q?3lTF8Ph8h7S0QLHSHle6B0agenqtvSGA/gPuIPAKqr04BxzqfATJP3uCjChg?=
 =?us-ascii?Q?nRx00X3Z8Kdt6FIzt4rz5r7RwYqlwT5Sg4NnEUuu0U1E4OkZsEdD+XnR3EWC?=
 =?us-ascii?Q?7waCWtOnhIIj9jGslj6qo7gOszOKrFYAb587sgERl0gN+CScbqilJxp34J6H?=
 =?us-ascii?Q?VF5507kUcy4GVuDBQ6UxQ0wHy/bFyXLjyYFk686Fa4dia5cMTqHrpyjHa8al?=
 =?us-ascii?Q?8tmaB0/ZylUHAm9mps8plH37cE5sVSxRY/5UJja8ybLLunJzyHOHxULWlMhd?=
 =?us-ascii?Q?KWtf53vkmkybKp1wH0I0sdK8Gft0grgdrAu/yWkXmADShtKp1IptCsxTyLn/?=
 =?us-ascii?Q?M2NYHK98aFc9zKn1tnXaghOp2vm2pGUZacs+sw90jlCkNkPGx+eihab5KaXP?=
 =?us-ascii?Q?ejTBy3dqfWo1bKJyW4HHfnSrEP7vVAfmw+LVwZo7SbGA2hbhxYKL3jzEp7l3?=
 =?us-ascii?Q?pLPIMqZ6LumnspyvXYUgxr6Y97aGRa6R4FPrMEBX0YnNDt+PN1vPl15/fByd?=
 =?us-ascii?Q?HTDyYQxQSCA7SgiZCIyu0dky6xBspmHIrb6hpnqmhFHfc26+EIx90Qp0XKYr?=
 =?us-ascii?Q?O7uHGNoZGTYVfNoQaKb/Th6RtfeqZw+RPBVpORWid5wlPfal1bj5p2fPhDfF?=
 =?us-ascii?Q?xIiStOSKtzg/5PriCTu9/QjuRs18tHMhemJgEN6xx3BER6Uk1rBZ4N2IhuiD?=
 =?us-ascii?Q?byQ3Hew+1f2wW+MUr/S0nkFwYZ/hatDvH6k31uxRU8QPStVtP7xx69pr8mUE?=
 =?us-ascii?Q?SFoUUmLch7QH97butjG9rNMIt+MRJfNBDn6PxkMFAlcLFFVxq0dDhZlUIu6E?=
 =?us-ascii?Q?WGDljezSXnqqcUlBw3Kd+O4sAdys9mpyn9hdEJkK2XdG6VyFRO8n65OxsKvp?=
 =?us-ascii?Q?6YCJ5Ni44qiH3iYxNyAJoOZwWv/kKSXWl0wdgXIAtOO7TdT3SMW7oqGXouVn?=
 =?us-ascii?Q?ydJifQRZL8BVGBClBeSRDmCGydGkdB/YBuVStz8dA76XpzzFtpErOWII2hNA?=
 =?us-ascii?Q?EJbGFA3yeCwNRUAKRzrnizhwzr8rLzvDmrEMAnUj3Yl7SPtVgPg6jNuqqIm/?=
 =?us-ascii?Q?jj3usoB8AGWQtusS5GMWBgkAZSTfecT+/GoISgU3LYiErVEyG/aZccF7DPfi?=
 =?us-ascii?Q?+6Q24j1nkb+CKmki9Hq4WyLN958z4IfA9EMNwWjSY1qPcVBIkXtE273CS2hr?=
 =?us-ascii?Q?j0NtZJcTpXrdCyoDptwf6D0sEi+xMDmiUobkYNsNti67gi3hT7S4s9F5HnRT?=
 =?us-ascii?Q?toxikkfrUlLAnXhaODmoxplTiic6prpX8g28fxP1Ayw/qnjYUrQVaZp1nEx+?=
 =?us-ascii?Q?zgP8+qjWuvmqOmQlHf43sCrbtQldAAQ8fxoG8JqUqQatPkxuyzyAXNWtjwpl?=
 =?us-ascii?Q?U5GIeHP2WRN5DYSrRwt1bX5XaP1t87v1QmngrzPdjWQYbxP+7+yYJZh9wdkJ?=
 =?us-ascii?Q?SZTze/htuhJOpiQppa6rJs2uLgDYKGw=3D?=
X-Exchange-RoutingPolicyChecked: OU+qL+0KbRTfHPU0YwoOzRUf5RMDrnFAxZr+Lu7867Fwek1Xygg8Qir0GmbC0vnQomgDwTAfILHDEmjqCLaJIoxisB7pERXxLKco+otAA1tGQvJ+B7LcR/NiWgYBWGlJenllJqgXvFf3Y/Wl37wbJKyGxs4ECNQZp2o19etVTYmDhJVwO0+3sQkpue+fPDO+XpB/bJ2bL9CmOM4xbMRJN2vDy+j0ITUtMA59SsClKaoxSTQDWruQhf0miL4SnF09wDtrrH9PE5BBHai9CZ01B1U3gIM60im80dtYYecyjS5IlI29UlrfpnEmU0E1FrP0kGSaUKFJ7tXRu1Y8mM+IfA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 84802ca6-d8b5-4287-89c4-08df3b937df3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 23:21:17.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4GbljOlSHuGi0da0rLgnOvQmSXrNTdxdEvqXEhakmFfDi45cgwzCgBBW3d8DrJYrVVORa24Aco1dlcuRqFF/QSuud4WUJmubLFgI1FpmYI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9011
X-OriginatorOrg: intel.com

On Wed, Nov 04, 2026 at 09:48:25PM +0530, mdshahid03@gmail.com wrote:
> From: Mohammad Shahid <mdshahid03@gmail.com>
> 
> pmem_attach_disk() allocates a disk using blk_alloc_disk()
> before initializing badblocks.
> 
> If devm_init_badblocks() fails, the function return directly
> without releasing the previously allocated disk.
> 
> Use the existing cleanup path to release the disk and preserve
> the original error code returned by devm_init_badblocks().

Hi Mohammad,

Your patch looks right but this leak is fixed in v7.4-rc1 by: 
855a46681e0b ("nvdimm/pmem: Release gendisk on probe failure")

Basing and building your patches on the latest tree, usually
the most recent mainline -rc before sending helps avoid this.
Sometimes a patch is also just on the mailing list, so check
the list too.

-- Alison

> 
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
> ---
>  drivers/nvdimm/pmem.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 5fb86595e8bd..76e80eccc8e7 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -563,8 +563,9 @@ static int pmem_attach_disk(struct device *dev,
>  	nvdimm_namespace_disk_name(ndns, disk->disk_name);
>  	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
>  			/ 512);
> -	if (devm_init_badblocks(dev, &pmem->bb))
> -		return -ENOMEM;
> +	rc = devm_init_badblocks(dev, &pmem->bb);
> +	if (rc)
> +		goto out;
>  	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
>  	disk->bb = &pmem->bb;
>  
> -- 
> 2.43.0
> 
