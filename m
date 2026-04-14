Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2952D7DF1
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 03:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776136505; cv=fail; b=SJBExx2CUSiK2l2VlR5BD7NlHeGq0GVEfcDloJjd+n1b7Pl21vqZE8Mlat85OzirBYnRYZUz5HR/3a8aqt5rup+IQ77uMraV+AYu4hcKlmXN/EAO40epd01YTXtTUc/NSXJXqnP0BJglwdj9vFYPVtZwyouOZYvJPcbMc4qBzwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776136505; c=relaxed/simple;
	bh=kz8uANr+sXogp/SdGBUnbC1pysxIHT2BPbGDhNB0VrA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=anNMVej7YWtBzXhcqjyO6i4xZvhayhU3bgjB1ivofy5IpvTUV8o03jiyT4v2xOy+tVfDJHgUAqYV0xi5V4Mc6zaHqoj5zCDx92NUjSPpi/GDzwwWqpIH79M2e2r+CMJL0b6gmktvVqXv3f7zp2+OWm1CMeUPv0mt4caJHaZ4pY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAJ+0j81; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAJ+0j81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776136504; x=1807672504;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kz8uANr+sXogp/SdGBUnbC1pysxIHT2BPbGDhNB0VrA=;
  b=AAJ+0j813Fj3sgVbvy9yrtzMhYX7s3OVMF2yza2ZgoKXMmjAFhxwFlBj
   GdqDTj8MLDM9DzwSrFmz9dGggswHZGgcK6+KWhBYWL46OKtwiTqcfmcek
   EUQbUhYuptjGKz2rVy0cfBZBx2fpgiPCZeSkI4PJd20K6F3ULSlQHD13s
   cwhmLKujuAOpnG+CxKitn4q5izAe/phl7oLwJbIkz6QEyqif06d9ks2xf
   gDQkl+ZgfWu1dXpW1OesBRZnipTOIoTnP2ZA+uKqc7XOv6ILzwyEOxPYA
   IAnhklYbSALl66mW2dYM/TWFyVSHpTbmL2pl5edlRdiqK+2pD8CtmagwG
   w==;
X-CSE-ConnectionGUID: EtGrZCyRS+2NX4DUzA6rdw==
X-CSE-MsgGUID: fZMyg9X1SI2aq8S/YFjDSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="88464459"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="88464459"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 20:15:04 -0700
X-CSE-ConnectionGUID: mgC1zkTZTku/Dxncf9QS9g==
X-CSE-MsgGUID: +BYqVJ2sRUmzqegvot9T9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="234897913"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 20:15:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 20:15:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 20:15:03 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.47) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 20:15:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SyeU4kpz6cCvGU4pQbQHGiwx/En9ASWqf2jTUbxzfhYQ1NiKXstF1J/F6L5uJLNGcHzvTxZMpX9fY3Oq3J9JOIHSn8EIcJ36MoOV5AdbJnJBP+9uQPBUmMebfz/S6Sksk6Bh5Ne4zeGNfSYlOaUQAlIbKDeul1+WEHKKdeFuENgsv8J3tVe7cYszp6gb7cd+o5a3DX6RNBtMjM95DWHNqh/SpZ9UQovsQkHJ/3NyKcmjjXulopA/IexoVzD97bs9JZ9clYVI9fTWn1Wxmns54GfqzgmkoGL3WOAIzrXHjHGRnS2e8NvP6NuvhXEXX7yBUe9as9VVCc5TYr/axiBNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P06m1ZSRTIQL0n/IOYTlNA4jPDxwgr7YRw4FmzPdnqg=;
 b=LCiHjTXYvDwykTZhKhTNkG4mB0ki1iUvhyRebQt8jRtLbjgZrnJHqtsoV1DpSl9BnbyifiEIy3XuWA+nWhcI3yPA9x9eHFuNov0gwECffC+XAB+LwHQI9VVtki6VZrI9J/+OQlV1QJLZlXJ5S7k3movQiB5sZ3vOh3/aS9KmCLs/cGKsiI3ny8PrC4c+Q+XS8i+xzlADm7QJtk3xUL87ncOgvZqpygtUDqyfYXUD3TW7H/7UvY3f+RN0vDMDVLQADcj82PDJg9BNMn8XrBPE/xMzDa7e+KeuhF6R7iN9gwulVtc7nZFz5NxNHay5T+Zi/9iFY3Dgjl+rjys2RMs7lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM4PR11MB5262.namprd11.prod.outlook.com (2603:10b6:5:389::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 03:15:01 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 03:15:01 +0000
Date: Mon, 13 Apr 2026 20:14:58 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/3] test/mmap.c: check mmap() result against
 MAP_FAILED
Message-ID: <ad2xMkWUrlhQh54F@aschofie-mobl2.lan>
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
 <3f34556e-c3b2-40af-afe8-0a907c00c428@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f34556e-c3b2-40af-afe8-0a907c00c428@intel.com>
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM4PR11MB5262:EE_
X-MS-Office365-Filtering-Correlation-Id: 01fcbd3f-f8f2-4e4a-90a8-08de99d40403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: W12MZVUoMWpM6+DmHJ9QAoWgpPzvMt8l63EkksHuxPzgc1Lv5EvAYtDQ9RAQBWp0netg7LI6N3ER+6L3nlsm4DGfI78+ecbtOhzIMAruoa169x+iNlxpuA8qM9VQTF7N/WdUPMnguOdOcUF2rGzqXSBSM+PoUpKViUDvlQiq5FVkNaevqNVBxZK9Xmw15Ri7ni/jj/jq2piShqVJkY6UvdZPbPG9gOh9zWu8o4P5L9bZk4NYSQFZnkm/4W1rbqebQVACPpL0um2pWjy+bN3CEBZdBrH8DcHmny9psKV0tRWNgLnXqJa29WF38k9Hd3yMPYUZFuAxYWxD9zLE5COcOZRAh34EmdxgqtWBZfI0LtxeSo/kNzaxLV+JAIPVFEHX8Dm29vFo1xSdJMCq2AdMihS3p8YivcwVTmuIgJO9k3nLOyKxoqzPHyGpGa7eOIfu4Byxpsp+EYRCW8VTnoSl41KwJQc1Ml2HSHvyE9vYMfmlzRoom4eWtAdAKaivhSkB+TiddKBlweiP8+bhI9CrLT5OBlXUomiKsFkt4PbYOW38loBf5etIfASHOXuQgKsS/QHceWPzb7+/la1BqYtUzkTcrJ53YlRlC6EP3H1sqEthQbKhSU30OVpycfNch7In61qRNCFrxPbkIL39QX4pytiFDkOvnNKNLagtGAUyyZCkhre23yB6JFXaaZD0vnftX10BYOw83IN/ACZ1J2divzqg5sjubN5+IbKncuBKnYY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meyObYft4zblDjehy6lm6p0LfEDG0nRvLDS9Ysh1gEDbJN8UlSMP4lo3nRUe?=
 =?us-ascii?Q?1HBETWuQpb6hytS/uQlZumQm/kEk3k5FJ63kBIy+2JxlJBiO5ru3ziIsavJM?=
 =?us-ascii?Q?9fIm7S6ut0UerrfpW11j4N6LEzdWkZ9eB5haC1ZMr+ph0+ZUghBQ2p6IMfhW?=
 =?us-ascii?Q?ppy52DIaEGKyWdOx1dRAO0PmFXn9jFHnP//6GJIpoG8LAwvLuq1aL7fxFi+H?=
 =?us-ascii?Q?vGijorQnTsAFr5Osld2DIIa2JgT93p/JyOZpp9juO74wNUsTvw7yL4aMflGb?=
 =?us-ascii?Q?Lkn8MNq2XnUpn51UyNKClzAr2PudRQpmgQsb+yxJpMdqqeUOCpxIA9RI3TdK?=
 =?us-ascii?Q?pM//O+CYfNG7iFYj7O6vy0jFmVKDOWAFu7KbLjw2BH7R3XhHidbtDftRgyHJ?=
 =?us-ascii?Q?f+zGVC7dUs+5O0s6hiRhv7YHZMDahaaGGJz+w9eR76JVShp8nw1QDPIE5d6J?=
 =?us-ascii?Q?KgHBTArLTpjxl6q2PmMal7lXKu6emUnMVn05L7hTlalbkKPHR/3BQ1iypWaO?=
 =?us-ascii?Q?3LtVUUNcLi9wNcP2Mf5ujqOHyOk5VYeoCDaGfSBCu3wkvh5YsdxWLqCKNjpB?=
 =?us-ascii?Q?cq2gINlJCa3fwIVYfglNQJGrd5hnifMWpzFs7PrqBnjqIYULrFQo5q0fH+VT?=
 =?us-ascii?Q?ZYVbat6TqHn9p69uNmKdBgwB6NBjqSylesVfwgUCSqrquvYtP10T9IXGSyd9?=
 =?us-ascii?Q?ciXhDOsW2n6uBPYkaznDjD76wqSzSA5yI2naxaheivGx6+4iqE+bwVoQrbw5?=
 =?us-ascii?Q?YqhfFKuupG//K31kzt6tpVvAnplb+gSVgBGcVl9foPUtwuk8ZSbfk92fhQXq?=
 =?us-ascii?Q?UiZxiAS6FJ979B0o1MBw/NpEYLapz4QtjMVi3hy579wSnc0cPDil27XmGElw?=
 =?us-ascii?Q?gSuM21oizBPAWqWzI1E6cpfG8uap4NPr/guGUFJW8HLbjDPqkesZW9Da4Yuv?=
 =?us-ascii?Q?SlQup1aPMfo6FmmJhGXfovXQglqUtHoSjahPWsgzUM9yUEnVhJzeczecAEt6?=
 =?us-ascii?Q?gMus98GrixpSWqB9LPNi+yKuJQCBoR6CJ+/LO2DylN4mT1feYoq1bGb7t+mJ?=
 =?us-ascii?Q?4IQx6EN6kl3NmArToMI5435tS12heG1Hm5ZH30gOEZ8rh26vuWSM3emGpXrz?=
 =?us-ascii?Q?DZ5JskvQfcXa/UJXjMuUuUyVHxRy2ZSPVdy+E5fKZ/ALDCGBEDmKPQcEE4oG?=
 =?us-ascii?Q?2Fu3qvZ3sh3OukkZCvUpnBZnXIK/8WcnkbPKMi41Z/7SsFNEG7rKCb+60mgn?=
 =?us-ascii?Q?m8QtSueN9H2DyKEwKik9+ppF50h6Rc0igp/Wx3PmS098UYA4utRcjPaZfZWG?=
 =?us-ascii?Q?x7Jgq7ZVm9w7h/vq0EonhDeyPQxCyAK3pBB0SKEAR2rKWr1eHcEp+0+FiP8e?=
 =?us-ascii?Q?DbbaMzemvqCOXppDT+jixaTQyPMtMpjEDVX1V8hFa6KGkBwmDGtvs05ibHbG?=
 =?us-ascii?Q?qXXsmiKIQnxsReyW1vz6ik8h005T7a7F4kHgFel6Jx8q1QPOQM0HL7q+B+Ml?=
 =?us-ascii?Q?52a23gJ8TxV++8fcEMDjBMM/FAfsgDOExl4zmh/JoBY8Qwa0jUBlmtnAsDJ8?=
 =?us-ascii?Q?aoQfdJ8s09VkE4PMkrjC/qjRMa4mDD203XiXnueXJgiKF9MvUaKLvUVgkxpJ?=
 =?us-ascii?Q?ZyzrED+4+4wxkyq7sYoq8woMQYxZxtqwN/TN5443dnH5EhxznuOt7HfRWBvF?=
 =?us-ascii?Q?uEmHb1etW101qmwL2n3uJ+nMdak1ocltyC9mZv1WJL4MqpTn6jQCx/lHg9yn?=
 =?us-ascii?Q?JZXnFmGXHA8TlKp5Q2HlS9EfNa/x/l8=3D?=
X-Exchange-RoutingPolicyChecked: Dk1mEP2Os28dvX2TwQA9Vp60baaHeIeIsflL+np32mCBUQ+DhMm0ryXDVWjk6/rCSlXEmCu88yqeogN5KTWZU1rf3xpsUl1ytA7FFVl2dnIKzbfxclt7X+X5NSbCsM2NBjU6Y4apNRpX0qyFIFjvN4eSnsvPp8yzh4IpnoeN1pq931hh05igQkCHwJkJF9+E+8rlr1ZoSMnFkJsm8S0e5dLsgFKP5OyQD/aJKczERf8c3H8xfl0dphdU0W3ugqMpxO9MVAYUVDaxvB1fdxbu2H/TZkWiipwZ5eK+V2HReUYIwLON1OMqjnCq0pkmLm7HhVnDW/RCiR2SBGU090BFAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fcbd3f-f8f2-4e4a-90a8-08de99d40403
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 03:15:01.4172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HB+GM7Lx/VmuLmP/d3Sxy2ByMINYiLtbS6v1qCxh8mYXZpteU1jw9b+BW7G39mIIHJAfOcHjjiQHAZqb1hccrQ0rL/bAcYxXnizq2v1Fhq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5262
X-OriginatorOrg: intel.com

On Wed, Apr 01, 2026 at 03:48:50PM -0700, Dave Jiang wrote:
> 
> 
> On 3/31/26 9:49 PM, Alison Schofield wrote:
> > The mmap test currently checks for failure by comparing the return
> > value of mmap() against NULL. However, mmap() indicates failure by
> > returning MAP_FAILED, not NULL. This means a failure would go
> > undetected and the test would proceed with an invalid pointer.
> > 
> > Update the check to compare against MAP_FAILED.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks! Set applied https://github.com/pmem/ndctl/tree/pending

> 
