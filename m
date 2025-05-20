Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D419827FB25
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747768123; cv=fail; b=VKDDPKWq0jrdzKm2oQvPaMD/ughv0U4km6nvywdXQuuRdFvDBe+VXylElyY+DrPOn0lMLc+yeMcaTqnVpgWOWBxYR7YdnhA82zsP80BOsK9iLF+aMgYBMXDTReIbje327xSsRnCAFsghkuLjsCRDZBOG2ZOzHGZL2vJRDiA5+8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747768123; c=relaxed/simple;
	bh=qt/M5tXaXUdQNuyKPCKSXXixlt8hg8w74mCLzkB6Ra8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L04yJxp33hzLiuTL4OaacwgbsI4T9BMCLKl6R+OpYuNLyuG3pQlAphAW9XEunn4E4WC9cFSLgNhTKxLL6n5rMLpmlElrIVM5pOhiMAp7w0PQSlB+eWE+GVIiaVDBXCQpFuV2azD6nDS+6cNhOi/bIXdbYQ6d8g0B6TdRU9V6t4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ua84GhUg; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ua84GhUg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747768120; x=1779304120;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=qt/M5tXaXUdQNuyKPCKSXXixlt8hg8w74mCLzkB6Ra8=;
  b=Ua84GhUg7UleP3sHcyHniM0zOIA78fTNU4fNhEFz3okVguedvE7qtBSd
   kN3aM3wppEfB81seKu7Hnss7rptP594jCgnq/KSMMQdDaYMTbFT9bpEoO
   PTsv8XTQ2lSDZAG2FDd9wq3fyb0oRg6nxq7bBQsVUCFO59uEueHUoMxhh
   ApgRft1fqSQ/C/q1xbAZWCGsCcCvxQ3qq3wt7N1p6BUUD1WwT0n0BK7Jd
   oV9W4Too3hr3rsfX/cJvwjmjzFxnUMbWtSV41YhLi0wbDTMr5751PIfFG
   uUiTeUKZUER9SCzHY+nE6QKZFAuvNlk17wG4gkGEOeFSOqWMsCITST0Sc
   A==;
X-CSE-ConnectionGUID: 0L/U3K22Sk6Cqpl4TSpBvw==
X-CSE-MsgGUID: ukLq3biRSPuGvTd82j91gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49420713"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49420713"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:08:39 -0700
X-CSE-ConnectionGUID: ZxTVbWSxTIq70nbTkSqW0w==
X-CSE-MsgGUID: uqfCwsYzRZabLLeGPUtdeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144524709"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 12:08:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 12:08:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 12:08:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 12:08:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkkOnNUkhhRm6uLcLBBqQX2ms8uIhmz1nEOVDH7LmiBLEs/oGblrdQAdcVbXf8Xf+Zq9An42qsUOAx14dSDpRZAiR/JyR9H3LXamftysyroRJ29LI62QE1ZUYiPmndQtFQ18RPazLaKrkyN3h4FCcUhhJmvO7BnDtFbXMqRhoCWvPYqd2qtjj1ex8h6iAbGqi2szv/aGM1zxhTXsSLjz5/bigWgLpCAEjdroVW/JTh5mh8FTkYR0aJ5QPkRtl2HjFVb3pO6OKZrC/LDc1BwSweGjshjjA0FiJIMogNwGbLVkz9LBWQnGpDRxEpqjAvlWJQYEDvc2LJ8z/uifucYoCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlt4g/UkkL1g5MlZnorzT+HS7Ysvvh+bLqnTTRK2vW8=;
 b=MIbF8k1K35/IcS9qHyApL4GvvfoWG08ol8HkGXkvBUTIl5lwYLdZQdlZpAC76BFXnycHgTSfm4iii+nWt4dEhZfKOTEcmtXf6OhK58jiy34WHoWYtCXEgyOWVIgrIir6U55qeB86z2qPeTFEhgBm67rLKci7WJVzLlC9WK8sukCVt7VjbxH1O2DyL0JyUTq9o6RPOnRHuKRIIpouXg/fJW5KSdpcECu2jFYriZjY5XNQKiJxEyBtc8pAPfB7WUv6eo832B2dUaBsv5pgR32B4/gIfQTd0ueTyxgYpCWWqFN/rK1N1UfbEmh9uaNSwUuW/1UuEbO6nMLURX6/mer/9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by PH8PR11MB6928.namprd11.prod.outlook.com (2603:10b6:510:224::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 20 May
 2025 19:08:31 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 19:08:31 +0000
Date: Tue, 20 May 2025 12:08:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v7 3/4] ndctl: Add features.h from kernel UAPI
Message-ID: <aCzTLHm_-nQduh4P@aschofie-mobl2.lan>
References: <20250519200056.3901498-1-dave.jiang@intel.com>
 <20250519200056.3901498-4-dave.jiang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250519200056.3901498-4-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::29) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|PH8PR11MB6928:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7dcf27-75ec-4c89-ec2d-08dd97d1b5ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Mlh0amUvWGM2dnV0MVBhcUViYzZsazVsOVhUUjlQNmZrWUdHVkV4UzBxQkhH?=
 =?utf-8?B?RmRjcTRhQWJXSEowZk84dFNsZHlhZ2JhR1hZZHJ5SGdUczVzSDVHbkZCVHVV?=
 =?utf-8?B?b3FVOHhWdlpzZ3NEdGpJRTVYUVhVbkFra1lVaHp0OGJ3TGVjR3p4b2sxVEgx?=
 =?utf-8?B?c3FVclNaMkNiRVZUZG9zQ3hrcTVZRmlkdDZ6RmFnNFhBbG8wVUJkOU8xS2cz?=
 =?utf-8?B?amdZNFl2ZGptOVhUU2hOblRzakFsUHRTY0ViY2FRSEhkYTBnMnFHYkNOcERo?=
 =?utf-8?B?bGZMYUM4WnBZMzNldnNRWU1rdmRuZ3cwcmpZZTZ3NmNoUGpTZEUrU05nU2lV?=
 =?utf-8?B?K2IzdlZNejZJMUQ1NHVJVldZMDBFSlVtbWFXdnNCRW9ORW5zOFBBV1JjcHox?=
 =?utf-8?B?ano1WlpkMVdMM3Nlb1RtNm5TVFhlN3hVbGJUN3lyT0lGR0EvUkt3dWRWdHZ1?=
 =?utf-8?B?MUtSOHAzZENyMllCWGRsWnROUDBvOC9NdEEzV2kyQ2xrNkNEYzNQeXVONUVU?=
 =?utf-8?B?RUR4a3J4YTVoKzljNURiMWdXdExnVkJhUFBtUXNTUHBxNE1FUHJPTUZVYjl1?=
 =?utf-8?B?ay9SV2xiWUVYYmVkcDV3NXVjeFplUXkwaUJkOXZCZkJialNqUnd2SmE0MGh2?=
 =?utf-8?B?ZWk5WGRJNTA3SGhsUHFtbVU4Q3hRT0RKSDFNWnd4YjAvT01UWHZOdEJhczZp?=
 =?utf-8?B?eXNKWk5mZHBsZXdlMmFyeEVyeGFrQlpnTTVBdUtncm9yS3FRMEozTEZ6ZnlU?=
 =?utf-8?B?OVZmSk0rYlFneW4ySlptTU0waHRDUVZXNTg5NkZ5TjQ2N25mcU9sSFE4b2Ry?=
 =?utf-8?B?K21QV044M3dzS1hGb2lBM0ZHNDlRRHJjVHpjUktUQklzN1VOcUVIU2dYS2xK?=
 =?utf-8?B?M2VMcUVkQy81U1lQN2s3a1kwck1aa3Jkb1ljdTV0VTNFcEFMNnIraWg0THQ1?=
 =?utf-8?B?L21QTTRxNUxKV2o3SXJ6NHUwTkExUU5QVENHTC9OdEo3UTJwRUpBcHZIV2ls?=
 =?utf-8?B?WW8yaEE2L2N3TW9UcmR0SVpOT2gxYTNXbURJRml4OFlVaDNKTTFaZjloWEFw?=
 =?utf-8?B?MHFGbTBrWEJDcVFoTVRvQ21WM0I3VkRHc1ZteFBXNG9vMlk3MEVjaDlmRnM1?=
 =?utf-8?B?VnhhRnQ0SE9wMlVZelA4T2tlNS9UelRqYjV4S0dEV0F4alJ1UmFWcTE3SDhV?=
 =?utf-8?B?MXExTXVxaU92OVUraWdvU1dnMEIxanNRMWZJanIyWFN0c04zTDI1REFGVTBT?=
 =?utf-8?B?WjNYRG9sRmpjQXpXclRGcnA1a3g5Z3JDenM0YkU0R1BDaXczY3hXRmlCQmJi?=
 =?utf-8?B?NHpuSlB0Zlp3NDNFeURRdEJHT2ppTHdQaXh5czZIUTBnMy9Bam4xVVcrT01j?=
 =?utf-8?B?K05GQ1d3N2ErQkw4WnFPSk0rTlptdnpMZG15TFpzZHhZUTNBTytJTVoxZHFS?=
 =?utf-8?B?K0czU0ZaUldheHNFWDlESFh3bDdsKzdIU0UwQkRFUEJFVmgzSXYvWGR0a0ha?=
 =?utf-8?B?TExMYWFJU29MNzduL1MvNGxiSlc2RjQ1dzdDU1o4d29oNHkxQ3Q5aVArTHN2?=
 =?utf-8?B?c1l6UkZOWTF3MnlmYkllZDJHaE5JWWxyZVJ5ZTNRVzhRb3RDTW14dGJTOE9X?=
 =?utf-8?B?bWhVQVcrd1ZzWWVyMFdYRmhnTjdyREMycW44VVozV1F3RzBnc0FGWFNadkVj?=
 =?utf-8?B?Wk5oR0ZZeU56MlA3Sm10ODdBTDBPTnBpM0UzZjJRaGtSdjIvTm5lYklCOEZH?=
 =?utf-8?B?MnJGbW9tMmI1NWtNeEN6eDQ1L2NCWCtUd0RxdDhNdUxaTWxXTGkzVmtSOWlq?=
 =?utf-8?B?a3JGSzZJcDhCc0JOQzV0dUJ1dXVxcHhUKzNlbXVYQVpkSnVHY3Y5eDY2QnZQ?=
 =?utf-8?B?ZDJ0VElUU0xMRUNyMkJvazZSRnFQMW5ZRlUyZmc0UGtGVEd1UWgwNUxjU0RY?=
 =?utf-8?Q?1vworzzODtk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3pWNmEwT1JUTHZUbWhvZWVzTnJRamVBYTNNd25NaWROL1NuaGUrZzlnUkNR?=
 =?utf-8?B?R0NiMytDM28vYWFBUktQNFhpL3Ezb29yOFdMZEYyeGpGSzNoR3J4TEtZeFF2?=
 =?utf-8?B?UFJocERqU2ZVQlYrVC9LVEEzTGk0NjgydU5xZ3M0VWpPMG9ORGxXWkxaYkZY?=
 =?utf-8?B?dlZ5K0R6RGtVYWc5YWhRTWlQZjBtUG11WXhOcDJBRXlhSXJXTCtaRFViL0xj?=
 =?utf-8?B?ZmZqa01Icmk0MHR5NDhlTllmUHlYOGUrdEVSc21hTGtRTVE0YTE4LzQxcVNr?=
 =?utf-8?B?TEhTeTY4RE96WjdRZVBabHNsSGNBYlVNL0s4QWFSeHRuYjA3ZkN4ZnhxTWN5?=
 =?utf-8?B?TW5OcFlaT0hZSElubTgzaldYMGRvOFZ1MlZrQzViQ1JsNXduenVITEg4ZzRo?=
 =?utf-8?B?WjJxVlk4eXNkQjRRU3oxOGhyVnZtbFhWdGRzWmhQUFR1bmk2Y2NPZDVhY0dF?=
 =?utf-8?B?UjRrSmJVZ1R3ZGtuVTFqMDZnMSs4dk8yS2t6VHJORGp3ZWhpZzh5VWRQMkpr?=
 =?utf-8?B?aWtwWjRIWTdZMmJMdTdWdmFNWms5YlBUTTFaVkozNVdjNGZvR2xoNDVJN3hW?=
 =?utf-8?B?N2QvNUJRcUN1TXozc2VSOWNPMURWd1h1SERMNmY2d2cxZTg5cFVpY2hqYnRr?=
 =?utf-8?B?N3doSVFVK3dVZVpvV29ocytCUjFZaWNvemErWlBmQWxYK2ozMnIyZVNpaUx3?=
 =?utf-8?B?ZytJSW5LTHBRcjc1SVpXUFppL0ZlL2JZZ0c0UDQvSVRhOEZXVEVmQWFxNy8y?=
 =?utf-8?B?ZTlYWG5zRVNPZEUxclU0VldYbDVkOHpnRmxuYStjWk5vem1VeDdaSkRVMFhx?=
 =?utf-8?B?TUxERmJSaENQRXUreU94WDdWb3dYenp1cGNRZURYS2RaVy85aFMyM3FoL2dH?=
 =?utf-8?B?dWpNa1VRUkI1WXNSZmRvMkRzRXE3R1BWMGRRYVVPSXhMTnF5MlN4RllNaWZQ?=
 =?utf-8?B?enN5U3MxY1pYenBZM1ptUHY3dUlROFltbEx3WDc2RExyRTJsYWZqRld3Rk1u?=
 =?utf-8?B?N3NreERkaGYzL1l5ZFFmT2JqZUx1VWxSNjErMzBmVm96NDVjdHFLRW96dDFq?=
 =?utf-8?B?eTJjTUN0RVIzZm50VVlZSFJNckw1UWFDdzVPZmRJbk5MclN3SWpBYmI0eTE5?=
 =?utf-8?B?UGFla1NLeWxod2ZkVWx4cGR4RjFiY2ZacTFVVUZtYW81MWRwTHZjL2UzNjRo?=
 =?utf-8?B?dGMxanp4ZEk3N2Q1eXRTcTNpT2twdEpCYklSS1Ntb01qV3dLRWRKYnl0UTNh?=
 =?utf-8?B?bzEyMDc3Z1ZueGhHRFZ3NlBEUlBQS3NUWFZwSlF5VTBqWmpBWXF0bGx3WmVZ?=
 =?utf-8?B?TEtiRzlUZkx1QjZFZ3BxRmNHcTMzNHoxdTY4U0xJSHRuWlhtQ1p5TGNSWmR3?=
 =?utf-8?B?ampxTDFMNURLNDFXR3YwMGdqYzJ4dW51SHpaWWZ2VGVuRUdMNGVZNStaUjMr?=
 =?utf-8?B?YldJbUs3VElYeEtOOTJvQTBjR2xEWUJCYmtXK04zRG1qZ2RGRW9Kblk1ZXB4?=
 =?utf-8?B?TERzdlJrcVpFWDM5YVpvOUpGcVByL0FWVWo3SDd6Yys2R3VZanlDQlNBZDZI?=
 =?utf-8?B?M1lPTUl5MFhmVEE4M1ZoNXNNc3dTYWZPb3RGZUhhRzlaWTBqVmNjVmJ5ZTFD?=
 =?utf-8?B?YWhxbk5OVUkva1EvTlFzVk9rQ3JmdHdJamMzTEIrVzNsei9XRUhzS29zZTRv?=
 =?utf-8?B?M3A3dkJ5Ulo0Sis4QnQ1ZlNSWHVEQ1I5YlhiSGhCUVJ4YS9jT0lWcEtEaGVU?=
 =?utf-8?B?b0VsQmdOczNpQmdrRUdGS2xTRUIxTE93cE9xSXJRZWdBcU9RS1JVS1FnRHdH?=
 =?utf-8?B?cXRYck42ZFdNS053b2VYOEk2bzdqOUZGR2lzRDVpa1haQU8yRkRzSmkzOEg5?=
 =?utf-8?B?TmI3U0tSb3NrVzhaTnhYdFdpeE9vb0U4Q1F0anVkWlBJUXIzVjQ3Wlp1RytR?=
 =?utf-8?B?Q3F2ZG1hMTNONnRsS3NHTWRiOE9ZSDJlYW10b0laTDMwUDBXUWVoajNMWWhp?=
 =?utf-8?B?UEhtT1ErR1R3QnY4dzZhYVMzRWhVeTFHYzR0QVZSeGpzdG1pTWk2WFNzczFr?=
 =?utf-8?B?enBRSDRlRWx6VjM2OWxvdlNwQ3BndlFLMENIM3N1ZjM1eFZyeWVVWDlod05H?=
 =?utf-8?B?RzFQb3J6aDJpYVZ0NzFxYTJoZzdFRWpnakdERzFvSTlWdkZPUDdDUFBtUTVQ?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7dcf27-75ec-4c89-ec2d-08dd97d1b5ec
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 19:08:31.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+Y/YWqHo2gN9YvdV4BALqOKM1B26BR12TF6rNsKFSTNZsgfnW5WrS5AF9DNO9933kqE0764ZmWBX/GErY7nM1XxOA0d16/l5G5jW0pEeEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6928
X-OriginatorOrg: intel.com

On Mon, May 19, 2025 at 01:00:53PM -0700, Dave Jiang wrote:
> Pull in the kernel UAPI header files from CXL Features support and FWCTL.
> This is needed to support building the CXL Features unit test.


__counted_by's got supported in GCC 14.1 and appended failure was with 12.2.1.
Suggest conditionally stubbing it out like this:

diff --git a/cxl/fwctl/features.h b/cxl/fwctl/features.h
index 490606d7694b..b71a2fdf2040 100644
--- a/cxl/fwctl/features.h
+++ b/cxl/fwctl/features.h
@@ -9,6 +9,14 @@
 
 #include <linux/types.h>
 
+/*
+ * Vendored Version: Do not use a compiler attribute that may not be available
+ * to user space. counted_by_'s are supported in GCC 14.1
+ */
+#ifndef __counted_by_le
+#define __counted_by_le(count)
+#endif
+


FAILED: test/fwctl.p/fwctl.c.o 
cc -Itest/fwctl.p -Itest -I../test -I. -I.. -Indctl -I../ndctl -I/usr/include/uuid -fdiagnostics-color=always -D_FILE_OFFSET_BITS=64 -Wall -Winvalid-pch -std=gnu99 -O0 -g -Wchar-subscripts -Wformat-security -Wmissing-declarations -Wmissing-prototypes -Wshadow -Wsign-compare -Wstrict-prototypes -Wtype-limits -Wmaybe-uninitialized -Wdeclaration-after-statement -Wunused-result -include config.h -MD -MQ test/fwctl.p/fwctl.c.o -MF test/fwctl.p/fwctl.c.o.d -o test/fwctl.p/fwctl.c.o -c ../test/fwctl.c
In file included from ../test/fwctl.c:17:
../cxl/fwctl/features.h:105:38: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or ‘__attribute__’ before ‘__counted_by_le’
  105 |         struct cxl_feat_entry ents[] __counted_by_le(num_entries);
      |                                      ^~~~~~~~~~~~~~~
../test/fwctl.c: In function ‘cxl_fwctl_rpc_get_supported_features’:
../test/fwctl.c:323:26: error: ‘struct cxl_mbox_get_sup_feats_out’ has no member named ‘ents’
  323 |         entry = &feat_out->ents[0];
      |                          ^~
[91/254] Generating symbol file daxctl/lib/libdaxctl.so.1.1.6.p/libdaxctl.so.1.1.6.symbols
ninja: build stopped: subcommand failed.

snip

