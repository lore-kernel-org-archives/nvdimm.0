Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793655434;
	b=wArEjXW+sPEG32sjh2BoDDyazET/3vZ+Mdls1uuFlAUls4x1ZSl4D6iSc3ZsDG70+HQU
	 LntFI7AVEAOI6LJ3o6XQwQJ4oVb7A30fTTWlVi73QG1/aVRMHVrIAGPzHfK2csBJxLP+d
	 48AMF7ktszPuc+YX3S2V2qbg/cjxXBtzY0g7MayZCuVZB3DxmVhDxOdlODTPK0Uv2jsXX
	 xpOG+VGUr40V6uGx73rimbYQZ3Y+phuNuP62FouLnBfUMmZzFvLilL6Q2vGuWFwi8fJGu
	 ACOiFt/NPiIYHiihHYZhiH89ZmMK+h86iEkbDE5DGtM15/DB2IAzjGw21i+0Ss8v6Xw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655434;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:Subject:Message-ID:References:
	 Content-Type:Content-Disposition:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=7IOYVfeMrNx1K5HiIfkonvbDJRDsuoWfNc9PlKZepPU=;
	b=r6qBt67A1lWTT4k/YaOoMap7BGpnHQsKa47MyINcqXtRkKLJVwt1+/aozlIG7GIUUPNk
	 af8DRpIX3zd+Mkn3usdbi0MwIeMjQW+SHXzae/weF3D91KNN5mfjsz1kguYAuCy9VMtMy
	 HXMbU0hkd1kIYZTTc5MCKyWGQIm6drQ7nR+KpbQXHrdR5n+vmC2OPSPrxeA/EtLvNKDbp
	 29twok/Sba4M4YDD4nHwrG216V6mWlxjqregc6iziKiuOd5VAkp+djR9N0+y0FXDcG+P4
	 /Ri0UzVQTi6mJ78kPRj+P2cYUfCdq2C8YYRdLTDgvwKZ6Ik9M1pGBKRlrZYg8psR68g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DMq3ftMG;
	arc=fail smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C076606D80F
	for <nvdimm@lists.linux.dev>; Mon,  2 Nov 2026 21:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C076606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DMq3ftMG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793655432; x=1825191432;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=OYgSpobP/+hH7jrV3SYWjP3b5VY6zj9VOk2OMuiOOuE=;
  b=DMq3ftMGsqbcH1DNCqRpaN/tm0TIPlP5NkvcpsoQc22qgrkR/OWpXefX
   vP/CLHgQCVHA3Y+9iT6P9v2FrX8yGBCrgric/IWh9WK1Nu6wWP0a4kcHW
   /tMG76as/BZ8m+vVur4+pal22+ArpJkk2LyaOh/NkLum6OVD+Z4lcTW6D
   Bb9qolvwrQhpHxjgLyYOtLiJFAVZhoY+obcQNtjmeAWbneDQXnVd1slMD
   gLYOsUX2QLhqNnHX3SJuUDJ2vFrliaccnf0wXU/m6S+dKC4V+Zx/5rH4W
   Evuuotlt+u4uNpA5+++LZSGg46Lg+HEK3OfIrYrVgDHKrMxxFnJNwcQr3
   w==;
X-CSE-ConnectionGUID: rJfiUSlMRVmIXmyLs01dAg==
X-CSE-MsgGUID: U+7tsVt9SP2NO4QkEFK8cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2274311"
X-IronPort-AV: E=Sophos;i="6.27,192,1787036400"; 
   d="scan'208";a="2274311"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 13:37:11 -0800
X-CSE-ConnectionGUID: 3LcOcFiRQaqhHFGHKgqEeg==
X-CSE-MsgGUID: 1Ho2kyqtQdS6bJFmELCMaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6357096"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 13:37:11 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 13:37:10 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 13:37:10 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 13:37:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPxnVLhfDab9Qi7UmQnHiDGKnRAE5QITGoZ4Db4QCIsu6E1bKHmm9g3RvfEpGZ9bEywyu1WrPzE6Edqh5DpVufpi9c3oK+YVDlOqHU+6zep10GpWjjtdIwzaKNXTCeAmC15fAUdH9u2iahnIKEG/SqRWRlN6vDfGUU/jGw4+wvxP/C5kidQ4IgGfoWqaozfZD7feMur9EmUwkc8+we2++Hflj9dHx5hJBq3c6FatIkhI+Y9ZKV6ERM2ApMgZUxrb0BVGBOOxNyKfU7YP9HbYLdhD21iX6jrU8DKwUWvLutaVaJU4zySEsbSjm3GqrYNSp/O7u7IXABD07gQnjnscew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IOYVfeMrNx1K5HiIfkonvbDJRDsuoWfNc9PlKZepPU=;
 b=sR7K0ME07+Uyk1Tvixw5NMenTboD58/FyR2+cOoncKSlfSvVLegABpYm45I+80LyqPsyBz7/AeYnlHp7LsFnkAw59wRIWB8CBFcN/D45eFqYujWCxuWLVxvrO+owFSTq4QTE+kghBOeK1LKNdjjgyzLvYf3RTqgLTFlbn6rTzZzXPwXkz2QqXh5ZVMPVYUucuRpBB+uydRmuQl3aBbbhRMWF8zBnDHVnEBgQFBttGt5sUbDT8Pjyt12SVY4GLbBVGM/+NJ3gB5nAu0UJmUQoVan5qZHSPZGivJGvmlNodJI1SALqgBaGbfDri0NXBUCyCGOoUn+nXcEoKiwmuh9FMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB8525.namprd11.prod.outlook.com (2603:10b6:510:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 21:37:09 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 21:37:08 +0000
Date: Mon, 2 Nov 2026 13:37:04 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/cxl-kunit.sh: enable running the CXL KUnit
 tests
Message-ID: <aukCgEAk1sm9yB7l@aschofie-mobl2.lan>
References: <20261014043823.295243-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261014043823.295243-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0217.namprd04.prod.outlook.com
 (2603:10b6:303:87::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB8525:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a107a2-5c4f-42c1-5d02-08df39297211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|6133799003|10067099003|22082099003|261102123227099003|18002099003|56012099006|11063799006|261022105027099003|261021121427099003|261026121527099003|261026140227099003|261022075727099003|261022113327099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info: SGMkH4IYF5Kl1Rd9DjEtZ+0yyC+jqxOeMlP4ZqzGlipz7R10ZaSoBT2BH1GR4S19UOGSpJ54ZITvVSdsKrFIqWx04GZJ3kDp17JMl7KYVErGwyZDhGkkouOSvOZgzGvui2TVCmenyTzBuT9itoZZjs4XnHDhR1CUq8RpVFRdABay/cotkU39/YYnpyHAeJsc+QeJ5aFzIHGOiLlho+AFzdj305PN33dNQcb0TPYSqHKUaV1/B7TEMdodH9LB/LPIjjXsefXhxGYbw56O6nBrSUWmuHwVD9oznUm2k/9O6xHGuWb2nX/YhGYshKTANsGrN7I9/5dxED9KsEsSHTALdqF4GWvgKionx09aeLxaxeY8eqa4JkxVhZpqhGxoruYW6pkXTncTB1Qm2bXUMItjecqhHesZibXmqyLskIwCRpD/mc8b8ec33DBGnHPr49mQnLMbz5bhrRkjEnozRyTm1kxilx/1VXmmA40j+JMUNIdyMR6n53uU3HNWnIy3QAeIrrWcxnpzaSJq5A0u53HBOJtygVatR8xuu0A5V1PPARd0MWblD1xHFjyB+4XC0/KTexXtvf6ZksO1egaDVfspbKXsp6qwPre+KZD2BYSEbhoEfgA5V6GfUnKyv3KSaPQo+30FjJuEqQfRbfK/WBTY+qin1t/SqxolF5Hb23KB8Iw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(56012099006)(11063799006)(261022105027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022113327099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HzcJqU6dTMSs9zpPIQDCLadgJMQKfVB4QMOhX25RsBXkPb9jkPMbdvyLRlQ/?=
 =?us-ascii?Q?/9dmAIrcZ7kB9PpJmvCHcFP368uH8Cuv9JFwsNyJypRZQOiTib0WY/SfStgk?=
 =?us-ascii?Q?xj25Utgr0JgZNndED3takxLmU8Xz+2W5y2SMPjSenNHDbjZ71wU1kXfVKOt8?=
 =?us-ascii?Q?+IbFAfEek7HcsBu3jLUkDo0vbzE5yLHw/hQ4eNwjJghgxdupW6vNGDXMeOSi?=
 =?us-ascii?Q?p9tr00C1baeWGlZDDVhpa8qL9ZyOg4Ozqj6XzAi3ewRwE8hGgwc2lI8SLa31?=
 =?us-ascii?Q?xBw0VzyI0gq4PcgrLF8FBak3c5AAKsFfQoOpXGK/D8hIfRkBM6EUnRm1Vv4J?=
 =?us-ascii?Q?5MyZlRMCeK8EELK1rxrhVLUgMD0+TCDtcsL4tMjjBJfoU/Qy2VdKEAf+1ZPE?=
 =?us-ascii?Q?pU6fxQyb94RZwdLHH335NidzqL7UuDdonjC/yqgswKI+9qj3dTRe1aeu6uxu?=
 =?us-ascii?Q?M2M9NhZl4C+ebbHaZQkh3iZ10JbSwcHzkkRv68JRpoTxULWyV3xchu58zjIO?=
 =?us-ascii?Q?O84DuOPCktj9VhAqnUhtiWu6v6rQADU5q5JHNi7nwlDw1z1YkDDT5c2gnv9t?=
 =?us-ascii?Q?r0RoHW6EYhAyCuFSXw5Q9OmaL7l5iVSrt7wvQHS78Kz8e6ALrdIcMw0HbzYB?=
 =?us-ascii?Q?FGwXk6E3KKf3D5JJU9tJlIZKhL5EAncpkYyGjTog+T0hV/i9nZuPX3BGqnum?=
 =?us-ascii?Q?ZqOOOhL49qu3TQk2l9oRtJH+sCn0s5ArcTfGSqAk7NqHiNsFEnHK68cGRJ0Y?=
 =?us-ascii?Q?V/RLmM4PQ2zJ/v2Wtng7RyMNkqixgeQOtMlTYUkex46Moc204uhDr/+KUWOG?=
 =?us-ascii?Q?CUYPXzF5pk4ma963IjxMOnYSQPuL3V8yoNshdK+vSnFPBT0A8n4ApLRImu2K?=
 =?us-ascii?Q?DdrSJu3OWw3H4FiGQd4NTK9pzqAE4RYZN7yyT8FxV2hMQALyj/O3lnysA/TH?=
 =?us-ascii?Q?QQGIwB884dfhqFg4CuSUdpEI/ptOvg9wtyNUoGXO/IQvAHfK/QkK71TFzDHZ?=
 =?us-ascii?Q?7MgWMz0Nyw1T+iq30RND76mG5d37PSz2xligSVtmyvhgBYqXMB4H8t+LIbQb?=
 =?us-ascii?Q?F6C3w2b6C9fDoCvOTmtEQP3LjeUCpBQKUluhISezg3odvsO76hYI6OTMqqbp?=
 =?us-ascii?Q?MabeiRFqVGmUkqicBO/OZGWXhydDwOSCL+CxpgLzOOf+MKk8dDpTYOBBaEJ2?=
 =?us-ascii?Q?wvBgs4VXdJxBdXx3FZkn3y3vZB3S1Cccw5wlZ3940LtCDlV4z2cdJiN4FaA2?=
 =?us-ascii?Q?ORGyIWaCbMGSV/EoDc4/nc/jEEgbl5otoJQVhbsLmWmC8V8365xf2trRLdb8?=
 =?us-ascii?Q?tK6KGETja6JqCdqGMsu6SbwUM4tohh8Oov925sFo5esNOciqXkwHgkVPzs9d?=
 =?us-ascii?Q?NuHqr5iEtrA5iOIMjcimHrJkd1mHFiym28qRZlO6OSGCa25hrE88kChgVVwD?=
 =?us-ascii?Q?4RRllPnFEveaQpXPPn1ocjDubXtTSxsnokJ8UVXSGJCjsFLuJsh1ywbQWNrN?=
 =?us-ascii?Q?F4a6Sgc0Stg+Bn68tr55a0f267np5ZUN482ahI+ycey0LMq+ELxNni7XJ5G/?=
 =?us-ascii?Q?eKMQ+aYbbz0k8FzycQZQGaC/ExcFzB1F3sS5nzRj31QHCRQ/5fCPZi3RDDKa?=
 =?us-ascii?Q?aHuG/vyJb0DMQ5jqm+YVB5dQL5Y9qr3J3k1q0JeR9Bq7vDRMDWlnKTFqhGsH?=
 =?us-ascii?Q?RRcXOj4W4OZFTFhmtqlpm9Pvx43cjRXqoenOn8nryQaHwMS85chWKyzaaSXO?=
 =?us-ascii?Q?ny9C9BVclY0Nvdvens8QMI/iclerX9Y=3D?=
X-Exchange-RoutingPolicyChecked: o7tyxZ9NfMv9kFuRDvWDac5wAytGTINxj4b8popk6ZCedqz+MG8Zldmda5lo+2e6BHJnGIDjToxRTrihjJ7g7C7aZEmVDDKJU1+VvXUuAFxN8bR3r40V7J9ZHN0g8bm7vnzL7jX02FBhrrdHDbDwtWuRDtM9bzn6v+bzuXUOdrJZX3LVeuHviOBeeLcK+5et5jNm5EO54ldTQR1go+qdOTAzcgTCsshPDqBW9s49fhC8oeyUOZY+jo8HmdYG9OcHyG1d9z34MfhsrUW5qK1/XcJaM4Dbvn1ZbtTgrthEkCnCUEo1hGpAkEUqkJ1p6MmRhFdVPDV/y6spZh6WvXmhRw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a107a2-5c4f-42c1-5d02-08df39297211
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 21:37:08.7256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ir8pAAGXum8WHg3eTmwcGlumaKR2XYiPsht61vh9QBWdsxlAtm0eCew++QwZj5Ll9QXVZY5HMeGbwu/igottsZvinYG48ElZXDuTXKlxxik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8525
X-OriginatorOrg: intel.com

On Tue, Oct 13, 2026 at 09:38:22PM -0700, Alison Schofield wrote:
> CXL KUnit suites run when their modules are loaded, but the ndctl CXL
> test suite does not load them. As a result, they are not exercised by
> the existing ndctl tests.
> 
> Add cxl-kunit.sh to discover and load installed CXL KUnit modules, check
> their KTAP results in debugfs, and unload the modules on exit. Test
> failures are reported individually without preventing the remaining suites
> from running.
> 
> Discover modules by the cxl_*_kunit naming convention so newly added suites
> are included automatically.
> 
> Add CONFIG_KUNIT, CONFIG_KUNIT_DEBUGFS, and CONFIG_CXL_KUNIT_TEST=m to the
> README kernel configuration.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Applied to pending.
https://github.com/pmem/ndctl/commit/6f65bf1f374a

SKIP alert:

I encourage folks to run with the pending branch so that you always have the
latest/greatest unit tests. In this case, you will start seeing a SKIP result
for cxl-kunit.sh, unless you are also running with the new kernel code and
have the KUNIT tests for CXL configured. The README.md in this patch describes
how to enable.


> ---
>  README.md         |  3 ++
>  test/cxl-kunit.sh | 86 +++++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build  |  2 ++
>  3 files changed, 91 insertions(+)
>  create mode 100755 test/cxl-kunit.sh
> 
> diff --git a/README.md b/README.md
> index a71db28f62fb..83e809a2b325 100644
> --- a/README.md
> +++ b/README.md
> @@ -130,6 +130,9 @@ loaded.  To build and install nfit_test.ko:
>     CONFIG_NVDIMM_SECURITY_TEST=y
>     CONFIG_ENCRYPTED_KEYS=y
>     CONFIG_NVDIMM_KEYS=y
> +   CONFIG_KUNIT=y
> +   CONFIG_KUNIT_DEBUGFS=y
> +   CONFIG_CXL_KUNIT_TEST=m
>     ```
>  1. Install cxl_test and related mock modules.
>     ```
> diff --git a/test/cxl-kunit.sh b/test/cxl-kunit.sh
> new file mode 100755
> index 000000000000..12e94e417cac
> --- /dev/null
> +++ b/test/cxl-kunit.sh
> @@ -0,0 +1,86 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Intel Corporation. All rights reserved.
> +
> +# Run CXL KUnit suites through the ndctl test harness.
> +# Discover test modules by name and check their KTAP results in debugfs.
> +# See Documentation/driver-api/cxl/testing.rst in the kernel.
> +
> +# shellcheck disable=SC1091 # common is sourced from the test directory
> +. "$(dirname "$0")"/common
> +
> +kunit_debugfs=/sys/kernel/debug/kunit
> +
> +mapfile -t modules < <(find /lib/modules/"$(uname -r)" \
> +	-name 'cxl_*_kunit.ko*' -printf '%f\n' | sed 's/\.ko.*$//' | sort)
> +
> +[ ${#modules[@]} -gt 0 ] ||
> +	do_skip "test requires CONFIG_CXL_KUNIT_TEST=m"
> +
> +unload_modules() {
> +	local mod
> +
> +	for mod in "${modules[@]}"; do
> +		modprobe -r "$mod" 2>/dev/null || true
> +	done
> +}
> +
> +trap unload_modules EXIT
> +trap 'err $LINENO' ERR
> +set -ex
> +# shellcheck disable=SC2034 # rc is the exit status used by err()
> +rc=1
> +
> +# Force test suites to rerun on module load
> +unload_modules
> +
> +loaded=()
> +summary=()
> +nr_failed=0
> +
> +for mod in "${modules[@]}"; do
> +	if modprobe "$mod"; then
> +		loaded+=("$mod")
> +	else
> +		summary+=("$mod: FAIL, module did not load")
> +		nr_failed=$((nr_failed + 1))
> +	fi
> +done
> +
> +[ -d "$kunit_debugfs" ] ||
> +	do_skip "test requires CONFIG_KUNIT_DEBUGFS=y"
> +
> +for mod in "${loaded[@]}"; do
> +	nr_suites=0
> +
> +	for results in "$kunit_debugfs"/cxl_*/results; do
> +		[ -f "$results" ] || continue
> +		grep -qE "^[[:space:]]*# module: $mod\$" "$results" || continue
> +
> +		suite=$(basename "$(dirname "$results")")
> +		nr_suites=$((nr_suites + 1))
> +		cat "$results"
> +
> +		# Match the suite result, not individual test cases
> +		if grep -qE "^ok [0-9]+ $suite\$" "$results"; then
> +			summary+=("$mod: suite $suite PASS")
> +		else
> +			summary+=("$mod: suite $suite FAIL")
> +			nr_failed=$((nr_failed + 1))
> +		fi
> +	done
> +
> +	if [ "$nr_suites" -eq 0 ]; then
> +		summary+=("$mod: FAIL, no suite results in $kunit_debugfs")
> +		nr_failed=$((nr_failed + 1))
> +	fi
> +done
> +
> +set +x
> +echo "CXL KUnit summary:"
> +printf '  %s\n' "${summary[@]}"
> +set -x
> +
> +[ "$nr_failed" -eq 0 ] || err "$LINENO"
> +
> +echo "CXL KUnit: all suites from ${#modules[@]} modules passed"
> diff --git a/test/meson.build b/test/meson.build
> index 07c8618cbc6e..3b3a634ef25d 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -173,6 +173,7 @@ cxl_elc = find_program('cxl-elc.sh')
>  cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
>  cxl_region_replay = find_program('cxl-region-replay.sh')
>  cxl_type2 = find_program('cxl-type2.sh')
> +cxl_kunit = find_program('cxl-kunit.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -211,6 +212,7 @@ tests = [
>    [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
>    [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
>    [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
> +  [ 'cxl-kunit.sh',           cxl_kunit,          'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
> -- 
> 2.37.3
> 
