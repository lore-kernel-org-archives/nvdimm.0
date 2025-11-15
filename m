Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E552C859
	for <nvdimm@lists.linux.dev>; Sat, 15 Nov 2025 00:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763167866; cv=fail; b=ZihSjt9lPbexqj1rokdbyTthAsV2mbP7br01ILjTRHYe46oDhYcMIkkoVadfoGkeFr1Xs/nLqGgt01R+u54GE5DkmBlw03NXQPBUfUOS9qVEYnHArgBxvue26WaIf1RsI/FHrk3mQzr3Nwvh/mcI/V0QnLh437/hmaCFQg5S2iQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763167866; c=relaxed/simple;
	bh=UHk423QoQJ1uz4k8iPBsWsyyMojHigB6FYgP9NoQVhc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aGbk9xFIt0F255tIkKQLXf+0pF4SoQEClygNEUtDfEb5suekPZDrUz4YJetj01/InnKxvNY+HX71HgBrkqjNmnb5IYJEp7nGFnWhlqCSSy5kshTftIX5sFvmFO6DouCZ4l8WLpoJlwa7zMmid8Fg79F6cp7e2oxnFoRL5T283dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdLtA2uP; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdLtA2uP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763167863; x=1794703863;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UHk423QoQJ1uz4k8iPBsWsyyMojHigB6FYgP9NoQVhc=;
  b=fdLtA2uP93ZGxzasLuc6DrAJ3Q9CHdXgvDrUU0I4ck9DNUeSvhGgQxj5
   74C0ME1QBpQFN6VTW8S6mFXWhOi0Zn1795ggICkBPSMKXBFsHUNTDjtml
   mPZ+UGZZOo8N1J5tlOb9OI2j6ah7Zl/wlpIRmtkxCczfGFw7tcvGwSni9
   WsLOd+2AS7T8WU48bCAPpsuds2dikrCt6WxMH/FFoNmMe2eXR8E/vbEUQ
   8+1jlluExfQ3w4X/0uRSSqLxpbewcmlEPGje1vXMwWSfJLYZUoAPoICXC
   3qOQH5zAjt29Fo4AXcybhoFWPW0yazhk8wlJpJByhX77GfnonHUH1qHeS
   w==;
X-CSE-ConnectionGUID: d20i6mhFRZSYazke9Se4kQ==
X-CSE-MsgGUID: zEwmBXCeSlmiOfDhgcybvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65363179"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="65363179"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 16:51:02 -0800
X-CSE-ConnectionGUID: tiD1ULJeTymK5neJ6oGByw==
X-CSE-MsgGUID: NcpXztehRDGYR4Ani6eBAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="189199418"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 16:51:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 16:51:01 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 16:51:01 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 16:51:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T8y3JyBck3wvdSFWUVGZOproubBBE9K96s19ljfXO24/eJjnAz/BwDi7CZG0uPTEuq9uSKISjwHZOBk8FVdb5uFxigYJAr4k1p1uluVewYbh05MHbxGHveou8l6mqznCvRTlfCH+XDC/6PfqrGJjV1edaOTbjT7lFnGbLVXD81/U+rJw1NahBtLHX0o4MwefnXhqisQ9pMyQfY6pBX9roiYmbgQXVboR12WHOTsPG9xSZnYBJEl8a7BhuaQ6lA2es+IXzO63Njf1QGdRc5FhTkv27P7jGbckMa31KDmZ2ZuNOnifx6ytRnjmQ2tNdmh1T+PSPUOaMdct8CQB1YsNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1cLmbxWF/ro/tHx544yvO34pajBJn/l79Tm/TtFNQs=;
 b=czQbtHSO0jbOaSQc7jJLJexpYYecKtPHMz9XFsQS4lJkZgH3wfzMFOfIrgpLkyh+5lk/cXrb5mvoWT4elot+lwtRgAIqutHh/c6a1GfO+gsxSLG0/boFiH4qexYuh5ZEWH0KlNinl2PYFaGRQRg4iY974eskfsTygatyydRLLrChbO23LdnOufn2FalSi3MZSaWLbXgeKhBjn939fM5aniwArSs+7dozMpA4OjuHYO/0lWRCCSwalsQGpdpBLm/eMGA1BrdPyjNvbLDT72zzahjsBV5aDV0gbc4RuEVJSCeMTwFq3G2gEXtgqVj9Oy8IrX8NP9rc9MIWxYA+6ToauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by BL3PR11MB6337.namprd11.prod.outlook.com (2603:10b6:208:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 15 Nov
 2025 00:50:52 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 00:50:52 +0000
Date: Fri, 14 Nov 2025 16:50:49 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: Dave Jiang <dave.jiang@intel.com>, Marc Herbert <marc.herbert@intel.com>
Subject: Re: [ndctl PATCH v4] cxl: Add cxl-translate.sh unit test
Message-ID: <aRfOaR1s2Odis7sV@aschofie-mobl2.lan>
References: <20251110021123.1506115-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251110021123.1506115-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0366.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::11) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|BL3PR11MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb8580e-2550-4111-8e17-08de23e106dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vOkUfaySRXI6dEaFr8t3EU2Unl8FyFobP3V9Yd2P30nt3t0ExFRzeR/ee+f0?=
 =?us-ascii?Q?pkrT58ME2Wj/WlR8AxJygv6uhEuZfwvcQPVtZSWKDAdAu5oVj0uh8UQv3VPb?=
 =?us-ascii?Q?1tFTn4os5SdiGDyC65gKNrkwwheT/VYbq1TMBQhjQNTZjIXEF/F0KBscv23D?=
 =?us-ascii?Q?DMbKWQLGYLCuwKQ6IJ4ictmFEExg+1limH+XsK6NRyf9Kd36Ga3pJxGCnvab?=
 =?us-ascii?Q?DM5kUNTlXFfOXpFMYGt3MExHF2knxyXI7ky+X0WVxIkeUncCuJ6LwV7yMo9H?=
 =?us-ascii?Q?sHic47H+jP9isyEebjYudovSFbsuOtg/SuHCMkoJC6hNK/a1nTuJkFPBzt6k?=
 =?us-ascii?Q?K6unDBLboNAGwnLHrP7wMK+L/4iIuzEOwAqhg3Kh0FsGgHiJPsU1IAhVXhAJ?=
 =?us-ascii?Q?t21I8M69XR4lOyGXGKSy5q0nCqSVmNCwrmqTq9t8FIgH+8P4IhykX64rHL+5?=
 =?us-ascii?Q?JxfG6x6VrtGz5fdsOtgStzLpZKBnNwN8PLpSie9vM2affILi7SWTLG0b9Kg1?=
 =?us-ascii?Q?wwC4mCI7fyZMNWoHNKLFNk79fYUYLETjJjUeebr0zZ5zj1IZUPJJCeFFDtPL?=
 =?us-ascii?Q?/PEDBNv4NEo7zk/Lbhqh+ssED5RVE1od+fOWlEfGHMsD4onITaYSEOzQeap3?=
 =?us-ascii?Q?4Cou3yPrVTrEtQOhQGgHtzGIECxjK+zAs/eW6GBQ0cKh2gyAA5f327+21x4R?=
 =?us-ascii?Q?pl3UNITotP4RNvzh8CJV2d5OIL2vclPK0PP7rYMH1zUwwUt0UuhU9nJe1Rpr?=
 =?us-ascii?Q?h4+rHVsOnzxRWf5HFHJ7IrbYeBtrkIram6h3+mao3Vk4dyh2ofjRodEyC1F4?=
 =?us-ascii?Q?gSVB9KlKGCB0Hqpm0R9ZlSYMwrqiw0Z832H9AQqVnLCNrISULTmAvUQIwG4i?=
 =?us-ascii?Q?CT4QEwvdx2SjlJqB6pUnMKS7/4izAuu92NDnEbN4ruehchPix6hIf0thbFl6?=
 =?us-ascii?Q?b4isVIOddnj2dlATpVBOlcwIiNEYLENOSxVd1TtMvBZgDRMkWBvW9Kj9IsDu?=
 =?us-ascii?Q?KjhsCDyYRS4IXcLSd0d4VzfY+2eue98Fop2BiQbv3Pn0RP1wXaT8zdVxi8CN?=
 =?us-ascii?Q?uVCdVqDiX8wsQUntg7HhEC0fjtvoQNs4sdg521mk/qfr8vBRC0cQ96Fw6qA8?=
 =?us-ascii?Q?zLkfnHtsBU3aNOlKhGlB7ErquP9WLsgjddZiiBRThXPBjjMKraRtqqGt9rCA?=
 =?us-ascii?Q?KCUGdy8is/iUKxSCqcwzTS4Se99piMiQA8BN4eXTnmH7QFtNV1v8k7hoqF5h?=
 =?us-ascii?Q?cgebQihHatvwEfpj+St/0nApyCZgxLIPoky5wgFb9RspyNVLWyK7AsmDXzhC?=
 =?us-ascii?Q?uz9IW4KZsDaOZtJRdr/ShVoWZCYY6GajQ8/1gUD8zNIn0lyXkA99HB8Nj8lo?=
 =?us-ascii?Q?0VsCXJ7dy/P9ZAFm+39FetIPmlmPl6rqrR5M7/jITFR2mP8BLvB1oLEG9OF9?=
 =?us-ascii?Q?ooYZrCojMSWc8oqq6XAcsal2ISR/CXQL1WdtgORs0TN9xISY5HfFRg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P4/tGvowmUq01f+eCSxxe2M8CKMdi0Lz1WNMbbWondSDjenePVncj6bGmMZ6?=
 =?us-ascii?Q?fTuCYSxi36TaFiD2LbBd4VBfw3E28Ni2trJnLsez6NpcRBqlmoge1Dv8LCVu?=
 =?us-ascii?Q?CuUb3aSgc6Lkw4HmGEEJIF+G1eNTRmFYemumssFT6VoboVpnXwJl4dlaB0Mj?=
 =?us-ascii?Q?/wb39fJkdHRvbbtQc3pSNUJOwMKqV0ZiUQqMuaPDeLdMYUi1wzPvIdBUrL22?=
 =?us-ascii?Q?hc2nph8D/ydJ4JhSXgVNcS0GjxocxwH9geWX9OdnzGfPM4x0EMvz8H2WzC62?=
 =?us-ascii?Q?hTV3pZUZR1D9UJxbYMWfqJJcystBi+8RXnU84DjdGSyGB9Qu7BIC+BxYCvCQ?=
 =?us-ascii?Q?WdVLjySW14Rn6iu6ciGHiHex8ruA/tLsc2EVf8rzcq/AXWXThf8H1kiOwRzB?=
 =?us-ascii?Q?9dmc6oJGm8NC1NElLDpNE59ObhrgpKqnW1kEgmnRCO9DxhTMYGSAKK4E0nSN?=
 =?us-ascii?Q?QxUb7KZrc2Q/VKmfk8fATL8fNC7Z2d4Oswyn4eJsbfDmGUSPQjmk+BHuOyXf?=
 =?us-ascii?Q?kEdKcf5RG1rJ2SJVwYWGP792t82OBRQRkB78Ln5SULBSnaG/xT2652SuXHVh?=
 =?us-ascii?Q?GfaTdunMMG/9vm3SAYDBtAOD2cM8EaTjwLDEHbBLvrk7uzr5o038A0QiABWF?=
 =?us-ascii?Q?Ywrc7dxs5rJhSp5fBM6L/NMcJpmsNmvbDjVHw7T5GjF1p03Pt0+yS/HBhS28?=
 =?us-ascii?Q?gSWLSdbzvtbiLuI5BuH6I9I8w3fPt7g0asnHKQOOAzJ5id8FbxvZVRFHMZsW?=
 =?us-ascii?Q?utbgEznCjmmCAkGesEivwkxZvNBVV36qi8pbEHUT8vMINXJMOCTdzP9XqgMA?=
 =?us-ascii?Q?EAcGhuaEXpejn8fmLg+dqxEmt9sHnX8YdjsSt+imgC8dPbBMHMAr7Ff1UVZz?=
 =?us-ascii?Q?0cKZ8+yVhGXO4/kQJPpvXtTiOkyhkluLn81U7ra/ORjRwRfEJIACKAPpv/6f?=
 =?us-ascii?Q?dLYChcpEkxphrxI1MNRXUN87jhkPTOCQIlbwq/QEZCOalWYQz98ZpFst65nB?=
 =?us-ascii?Q?WRPMU09FHN0bg3pnagaSh0n4vZop7ro6ULV5v58KvH+7Abzimnes7Ulo9ZBl?=
 =?us-ascii?Q?+iyxQKoOXLLP/wPftgNOiYYtdwh9X1q1fUMQjDfuS6IK4oZHimLLhNVvfqkB?=
 =?us-ascii?Q?bV3GhbQnpN5cUExPkYjFgLsUAtp5q3F4SfjdhV92thIE9tyfH39AhArEFJCG?=
 =?us-ascii?Q?9z6BHHeaQTAhtk/B9KMl8AIL7qGIl9ulDvLxSMJRGt4lI4QMVvuU242wyE/b?=
 =?us-ascii?Q?jJHfkAZpa3gVRbU21iQWgtLv6avc2zOT+d5WbOnpaWu8b55SLwb1k6FsPX/u?=
 =?us-ascii?Q?yVxXJf4R3SN+g7E0biqSos+HS1Yg5YK/D2fDUVnoCajvX79UQbIwix4KO5AU?=
 =?us-ascii?Q?dGndDx/VykyEU24C2WE57N7uHqD02b7G3lek1Ov1fWTF13H/c1w4Rib+DHzx?=
 =?us-ascii?Q?6y13iD/F8sXq1FUuFd1YpYmhnGNDhEw1GJb/Lg02xJvPcm4hgL8yzQktmMOK?=
 =?us-ascii?Q?oNGPXY5lBxHxnTvjfNGRd2C6IA0cZHQ+MR683GgngpRfC4zLN6zVxZF2riEN?=
 =?us-ascii?Q?BanHfxos5cgRl+JLtCdD/TQLxFE2dJUQzLMTNhOoXrMouy2C/sOiG9VjAEHz?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb8580e-2550-4111-8e17-08de23e106dd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 00:50:52.5656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9lZ3wbG07br3daDEbDNwwsDGgdyaFtGzhlAmPSb7cDo0LOkcnDqHWmhFyi/Dis8r9onFwTMVtfi6+P5GrXT2N8cXUzoqLXQa6tV/Hva+xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6337
X-OriginatorOrg: intel.com

On Sun, Nov 09, 2025 at 06:11:18PM -0800, Alison Schofield wrote:
> cxl-translate.sh performs 2 types of testing of the CXL Driver's
> address translation capabilities:
> 
> 1. Parameterized test vectors:
> The cxl-translate.sh unit test feeds trusted data sets to a kernel
> test module: cxl_translate. That module accesses the CXL region
> driver's address translation functions. The trusted samples are either
> from the CXL Driver Writers Guide[1] or from another verified source
> ie a spreadsheet reviewed by CXL developers.
> 
> 2. Internal validation testing:
> The unit test also kicks off internal tests of the cxl_translate
> module that validate parameters and exercise address translation
> with randomly generated valid parameters.
> 
> [1] https://www.intel.com/content/www/us/en/content-details/643805/cxl-memory-device-sw-guide.html
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> [ marc: reviewed scripting only, not the test logic ]
> Reviewed-by: Marc Herbert <marc.herbert@intel.com>
> 

Applied to: https://github.com/pmem/ndctl/commits/pending

