Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595C41FC105
	for <nvdimm@lists.linux.dev>; Wed, 18 Dec 2024 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734561017; cv=fail; b=ftfHLWJZzBkBAqvOUUoikjJ/PxMBxWc9dQS60MoEmAl8f3z12DPwfN5kPcOwM1ikr4olqCo4qRbc51vgnMF8hZDGnhpE7gY2T/HA1u949tKwzEJ296jmFnEXCiGGySXExnZQ3BtHRRIVcBnzJRKQRMjXj+IgvIrDOcGGI4CCOC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734561017; c=relaxed/simple;
	bh=GMMoM3Y5lZ7HSlh4O3XWRdzlavnPZ4XsXb5yc+2G46k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=igUtGd0FYZ2z1VV+Tq2nfh/DsWlLfx1jHGl3wulEAAQgfnULZYeRbYT0HKjgEIZV2UUsK87DSzHg5z4xSj+BFcikag+Ua6TZLW/tyLNgKgF98STRNW82APMQz575dAtLOj3VmvqEjOV3Ouv84coDAKDW8DWbCv9nIAix5lwgxx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZlQh6EOl; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZlQh6EOl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734561014; x=1766097014;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GMMoM3Y5lZ7HSlh4O3XWRdzlavnPZ4XsXb5yc+2G46k=;
  b=ZlQh6EOl9os3mkI1o//ry7PztRIIlYcvgZB/3XDMWP9164fmW3f5Gkif
   x7QiWmPJq3nAKlKlb5SEV7yXpoESS4lpqiJUnYVqdYMdWQ9YafF2ymjuH
   Lzt9bNQ+aXqEJyaaz2B14fOSoNJnbvTqqo0pAt91xAiA4Z0w9NzszwKV1
   60g3HpJKLF0ie6ZO668BEKmzbiLZDTGRIwQjyxgLkzdjfs37KNOvDn/fY
   WJfKJi4ioBY6gRAVab1lMlXonkeix2jsv1uAfYoNpLAE7PeHfgV++6Keu
   MOLW8+eqYHgVKyExRzTGliWzciHbTP8cv83e9tEqlX2cpVgMKJBbJ4hDI
   Q==;
X-CSE-ConnectionGUID: lyW08E1FS7SkVmy+go9BMQ==
X-CSE-MsgGUID: Do1eP/lpS+6tP5uov8E4pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="35185588"
X-IronPort-AV: E=Sophos;i="6.12,245,1728975600"; 
   d="scan'208";a="35185588"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 14:29:48 -0800
X-CSE-ConnectionGUID: yGYeFkfYQ9SWLg85K9R2iQ==
X-CSE-MsgGUID: bqiIidvwQ6aFjRjXiIv/5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102139457"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Dec 2024 14:29:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 18 Dec 2024 14:29:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 18 Dec 2024 14:29:47 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 18 Dec 2024 14:29:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S4OVrPQg6xmWX+P21wL9swo0xDdLVDenbHsNAizpCbympSlxDkZhlUFg/zIu2VfpuN761ejOSu2eBN2sPb1cm7lmtrOplOqxrcFYlA/durf+WuZbPsY04zAB+uX8lkEx/Ei1yiuFSYQVAqjuHrsnycbyZurS78YnH5/EjMsOIcB8DdmrV7eTKK4Udn2KdMWfahCWzUyAm3Cjytfk0Jnh7Z9mnqXoKD6L0ZCGuiXDSTBBFq3jRhrlH7qbs00F9w0mCfnoTRjqokpD7CFVXm04VPVMkJxacd7KgdLMVDCDf79IILUVlQFisGEUs2g1kmb9+BcG5D85q3WCRMXNPd/nIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzYYaspXqOPjgGoRYgsWM6sQ10EetLZusnbEaCn0w00=;
 b=QOjzmsXblNAAtvrC0PPy19GyuCnyJw9xI8VW3y6vYti02iEUY5ygB4ptSPWg0ugGvUd8t0Q9G8rsCf2H0U0pute7km4Ym7wKYDqrDdZ8dKzb4kNAUhQ7FgD5+YZLN7Q9WNiXgNA/UyCk455gQIJ4tknyU5MepV/pKQqsw4FX00ZCasnNw3X0MsA1UKx9L/88rcGlAUypUPtt2lotVkEu459a9+V3KAeQFz7LKCMA3b2gK4IaN7zgpn3yMg58IV5bpTbte5dZyIgr8lFFGXmbIWfRBhlgmEOBvXuBPhP9jvEbfWEOcy2h09iynAaLv0fUWIMV1lFJtrXW7MKx4YazxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by SA1PR11MB7063.namprd11.prod.outlook.com (2603:10b6:806:2b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 22:29:44 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%7]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 22:29:44 +0000
Date: Wed, 18 Dec 2024 16:29:40 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <lvc-project@linuxtesting.org>, Dmitry Antipov
	<dmantipov@yandex.ru>
Subject: Re: [PATCH] nvdimm: add extra LBA check for map read and write
 operations
Message-ID: <67634cd49d098_2c1f7929481@iweiny-mobl.notmuch>
References: <20241216123712.297722-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241216123712.297722-1-dmantipov@yandex.ru>
X-ClientProxiedBy: MW3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:303:2b::6) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|SA1PR11MB7063:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3bc381-eb65-4fbd-c418-08dd1fb37874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oRDgasy5q2qzusuVM1iHFMKNdHOayo/8RyF2WIUr95DP4PtK6+s4bIY8ZkuQ?=
 =?us-ascii?Q?sNph7gSnxH2lD8Qltmr+XpUcCeYeP6fWbWwyKi/TYTdDW9Q1uYWnxynzOy8J?=
 =?us-ascii?Q?BmwWdqH8tDEGlyTZxrMT8ZTZsFUdLenMjj9Ocso6SIVQVQguC7Qg+bmwuWaJ?=
 =?us-ascii?Q?4a9EqwKN0itsLOqRHaoCe9qIRRPs69fqJl1otDXbNVXWGkLVXfA+7mQmfAWY?=
 =?us-ascii?Q?vuRCPb2xAFkyoD+kFSYZ75gzAL2WELevuJu+CjGBY7LmeOXtqhgqbCFt4lR2?=
 =?us-ascii?Q?5yWLKqjzjHfVE4gRdopmLaiHqCWQM8sFuOl6DBbHV0gsYpNC8ziAUFa6YkLf?=
 =?us-ascii?Q?VEZakuWNq8lSf2YyC4KR3YldnIovVlk2sk6BqtdU1HxRFhyYTEdvBAR0rF7S?=
 =?us-ascii?Q?i7H+sc9RUjPsZxFVhjbhomwI52Ra/Gvk5iWEfu1EIy5ueLdg9U9KQverT5eU?=
 =?us-ascii?Q?WwgKM6VSXHSf4w23JY3yBVENxvj+INAUg30ae9Ijimg66G/3hVEl5xudCFw4?=
 =?us-ascii?Q?Wcew7OhPEmxUm4kScOpeRSde8BeVVOgFpFhktHKHDBx+3ASoJ4J+JAvWngb/?=
 =?us-ascii?Q?R7o/xhYAVZveB8SD4o7hf01qj0IMJMBTkGtocTdlgOP3yKlMokqJkXWiH+L7?=
 =?us-ascii?Q?FouFWlmI4Pa7eI/AtPWbSKDvtRxLX30amfGKxyOHu9GR7zo0v8BwY13hbkGk?=
 =?us-ascii?Q?iC1vfEqDkN+DVwLP3ZBgIwd3QhvOuo9jVP0B8leomykXUsQs86BFIHO4eRHb?=
 =?us-ascii?Q?GJy1ETWsHqGJKc54bDXjEGlefzBeRcreQwC5xIDOYspOcSK4oRMWxWEBPJze?=
 =?us-ascii?Q?2e5VZir8CK4rzw9CadA1gF1npSqahq/5rdl6Ykja46VgAoeqcXz6EzVLjKXr?=
 =?us-ascii?Q?DyP66CnXae1W/AfLb/FknafHRAh6W+BIZSksMie3KxPF1UmOtMXrMBr2pK3R?=
 =?us-ascii?Q?yWAsW+rtyDbwEt4n7ppyApz52fAqFvzl68JDZS0KmpNxEyQqDAF4yMdzxS0k?=
 =?us-ascii?Q?eCSoxu+1bx3fm5JMnN0Hxi+UqHryIewuOzMvYIIYt/OaZ7NU5SNICEtexfRP?=
 =?us-ascii?Q?uovV4r/twd994PPJEUbd1lc356zDN5hAFPOX0Y8O+9kyynHf9II7Hqtjsb3y?=
 =?us-ascii?Q?zSHbPyLj7emI3vaFf72hwJ0OGugEBKH6hObNzJRVQ+1cmcGS7t4TUCX9zzsa?=
 =?us-ascii?Q?qcYDUaoBz1QMeo0wlsR7yJ6wtzUnalxM10pYuUypjd5z0ULJD+SsP3hIAwSR?=
 =?us-ascii?Q?OAxQWmTTDTj70VK9KqpNbNnyE/yLyoJ7H4xAiHFiWkkyDKRdfT46JESI/dgg?=
 =?us-ascii?Q?dwZE9X4EKOKDDSLsol4fldrnA+DSISWKT23fM+yK+TQ2vp2iU7OjjAU4pP/u?=
 =?us-ascii?Q?0swf5fthhtbs73UwmcM2hIbUUB9Q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wnv1wR5yRvjzxJ97HDImV89suuiB3A7pUKUWNdsgA82fxJ5FWI8hrMEoMFUv?=
 =?us-ascii?Q?q2yMydOKD1a8ItL+9LroV8iA4rrjvzvoyqccBhcost5P8HonXTf4H2jUXtdr?=
 =?us-ascii?Q?mUxMC+qxa9B4SrcUDkPhf8Du71VoBRMkOTBTaSLliz180nI6G+69s+K4pML7?=
 =?us-ascii?Q?LZ/ce8zjpcsAvPzZUm2qAxMyl+jnNsgqk79NwoYVub58PYnAunWYEXo/kAlJ?=
 =?us-ascii?Q?cyThZNiGnCSFa3xxoPJt6bhiJfK4YJZE9eO0tQD5h9irob+qjMlBvV226SOJ?=
 =?us-ascii?Q?6Jj7zocCVmEP47VUzcIvZxUXcp1bgmZ1tfPliiolbeIXfLciXvkUYGK9t5yi?=
 =?us-ascii?Q?ccJsXiOosuMGLYX6SeZ6XTlsHpoCkR436fJI6ZytbX/GDU4ylTEPYu/STBq7?=
 =?us-ascii?Q?8qi3tUCJdvFB1mKshCwFPg/4YIvyYIifNDAMNHaZIaCyfxSIQp7MzXvSnG5j?=
 =?us-ascii?Q?E9sohSJFpUSTF9veu+5uOBYcI4ybRGwhoVEV8GezvI78+H8d0QqTZ59IDlXa?=
 =?us-ascii?Q?IRCuXoESwhoT1UllFyMFr6JuuKqUYwWlzz/WwEcfzB05Fy2bDwN9zgmYh9BE?=
 =?us-ascii?Q?39qBwO2tz0KcayYN7d8ZYY80IZ/TeC4PQMKaDLrnofwk1n2m59tFQp+RorO2?=
 =?us-ascii?Q?ydtL3Y249991SCQH85bR4ENDSjVmnW1Fsq5V8jgpf1wjJzJ0JGs6Q9Hh+Z0r?=
 =?us-ascii?Q?vIG8+WCNJ71/41CYjCUlwX6Ni7qb3ahJUlsPaLy9YhEH7fIG3N0OTiSVUDwK?=
 =?us-ascii?Q?la5U/lU3pGUKiSOC+P/KYOjP/GHfvgc6I0EjDS00oEwlBKP3yazEfDFnJ4oB?=
 =?us-ascii?Q?w3Yh5wlqSZMawvPoIjDzYW2SZwNv6U44TRu5UUyZRzaCvCK9Ks+kkX9DGp+7?=
 =?us-ascii?Q?l+yLh2xr3TXslz7IqdSO1aYEm/Fi24TAa+OkXCRli1ar331iuna+yOGoTcoQ?=
 =?us-ascii?Q?q8gbKOg42m1kR31FodRIXQSFZQLQKapmwrx/6Rg2w5sW4hePqPfIiNmi8pCU?=
 =?us-ascii?Q?k1jRcdDudh/icNYOIqan9kBWNIha1L28Zd8+Axm9NmQPEQvlzG82IyGzjVF4?=
 =?us-ascii?Q?I3nX0HVUkcTVmc8aTcR4Ge4iUTwXhXLEQjOj/LI9eZvIuhTGy4GwaJWE2u8d?=
 =?us-ascii?Q?/KncKWlSB+H+PZMqJNuHBdGB5qt1mcdDohtDTjLUgMKiuTpBOoA8yWP2f0tl?=
 =?us-ascii?Q?BmdZHr7V7Mvg1CDFpuYuq4YuXs8FLOIfZ6d2HyQf7+jdnI0+qkDLERYyTL4V?=
 =?us-ascii?Q?aXpioaf86Isdf2tfsWo0hmWhIQpCZQZV1XOtI/YcgEEL/d753E4/znp6rk3+?=
 =?us-ascii?Q?OA0oJZV8bf82qccoOKqKfoxRvs8CwDT862dTUABW3z2kuGunzTDdc1ybPcyt?=
 =?us-ascii?Q?+kZ4W+4V8j0jmsiNZFBcvB1RrpXBxlRyOgB62hVTia4s3TCIT66Up01pZ/Qq?=
 =?us-ascii?Q?zeTzLg4eYMcJiML7ZY8NVdnP79wIcS0Ub0hxIxfbycmE+754qf15ZgKtOciy?=
 =?us-ascii?Q?yBWlfMBzBPYD1rzgs83pxi0bZ8J36e3u+ykJ+/rhxSzZo4Ap1aLHhDBqoOca?=
 =?us-ascii?Q?h88pIGPUGAUIJZUdOxj2x5ZXQpZpIZLAyJVnCmIk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3bc381-eb65-4fbd-c418-08dd1fb37874
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 22:29:43.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vusxQnPWNgHfrOXX75Z8PXl5sTjwep2FQfCcN2mhHxWiHnJRooj+jQS2NBa56pgFN6QvL2+6sRb1xBFXpgKBKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7063
X-OriginatorOrg: intel.com

Dmitry Antipov wrote:
> In 'btt_map_read()' and '__btt_map_write()', add an extra check
> whether requested LBA may be represented as valid offset against
> an offset of the map area of the given arena. Compile tested only.

Does this fix a real problem?

Ira

> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  drivers/nvdimm/btt.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 423dcd190906..2bd03143c8c3 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -96,12 +96,17 @@ static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
>  static int __btt_map_write(struct arena_info *arena, u32 lba, __le32 mapping,
>  		unsigned long flags)
>  {
> -	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
> +	u32 lba_off;
> +	u64 ns_off;
>  
> -	if (unlikely(lba >= arena->external_nlba))
> +	if (unlikely(lba >= arena->external_nlba ||
> +		     check_mul_overflow(lba, MAP_ENT_SIZE, &lba_off)))
>  		dev_err_ratelimited(to_dev(arena),
>  			"%s: lba %#x out of range (max: %#x)\n",
>  			__func__, lba, arena->external_nlba);
> +
> +	ns_off = arena->mapoff + lba_off;
> +
>  	return arena_write_bytes(arena, ns_off, &mapping, MAP_ENT_SIZE, flags);
>  }
>  
> @@ -154,14 +159,17 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
>  {
>  	int ret;
>  	__le32 in;
> -	u32 raw_mapping, postmap, ze, z_flag, e_flag;
> -	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
> +	u64 ns_off;
> +	u32 raw_mapping, postmap, ze, z_flag, e_flag, lba_off;
>  
> -	if (unlikely(lba >= arena->external_nlba))
> +	if (unlikely(lba >= arena->external_nlba ||
> +		     check_mul_overflow(lba, MAP_ENT_SIZE, &lba_off)))
>  		dev_err_ratelimited(to_dev(arena),
>  			"%s: lba %#x out of range (max: %#x)\n",
>  			__func__, lba, arena->external_nlba);
>  
> +	ns_off = arena->mapoff + lba_off;
> +
>  	ret = arena_read_bytes(arena, ns_off, &in, MAP_ENT_SIZE, rwb_flags);
>  	if (ret)
>  		return ret;
> -- 
> 2.47.1
> 


