Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8500516DEB4
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 19:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524672; cv=fail; b=kQ2o+lL8XqExX4OY3ZNoIKNWxeNf9kzClpyQRAgTuwLJIplQF7cWsBXffoo4mo7uSzf4WgQB04+84HFWf1qbalfgfxEUekCzFRGeSESpR3r+8h/+4Kuu489dPvLUoa5Ca5Czv6e6sTQcx9b6rRNyPgbex5oxtEd9Xa7KSAl3jpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524672; c=relaxed/simple;
	bh=Ugx7/3jrUIie5UqtXWuuzubBXLN3omWeLdyzFZ0oGPI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Np2PPGLW+CfNyYtTyXzw0oc7APOmm+QoVYbGwuLYo7421qSNkqybFytfcDhUpeAGxh72MMkzFUHNgsHWLGUU0PvEmzjwJnHfZH5QUAu1pbif8fOJJ+qyhy/VGPz1cMaK6KXcpd0Uc/35C2qzObwfek4QyDgtxLmNna/dQB5Do/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RgHLuQ0+; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RgHLuQ0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731524670; x=1763060670;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ugx7/3jrUIie5UqtXWuuzubBXLN3omWeLdyzFZ0oGPI=;
  b=RgHLuQ0+pjhRV+tFnOX7hRsHRlGY0xfe8CORoAfH4iu6JoBwZ0dHBUOk
   Z2Be6GiUBabGVC2D05DEG5+XmYaVVIDPF8oSSqQYzApi5mysLwOxRPRlm
   LTqB20F0V5kv7fKR/VTlqDliqcRGHPJ6W1XKgN0jITHhklPy49J6jNp3E
   W1MVCD2SOFDz+w3Bw0fA0T/MiLRGtL4LcGElVszt5dRWOaP2ARv7o1zuV
   OliTlhkH+HKm2iIL+rlJBDbM5TqLUNWUgXPwofDG3rqiZa/oMTxdy6XKK
   cGHr9nJ2Rgpjls2PO6P04kngWlg83pzbOpkDT4yH34Y75R4Oh8GukYzzW
   g==;
X-CSE-ConnectionGUID: Ch3c7BUWR3uh+2+yxD9H1Q==
X-CSE-MsgGUID: L6j5vTP0RtGEyvBlrkocCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42047975"
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="42047975"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 11:04:29 -0800
X-CSE-ConnectionGUID: zQz7OTyYR+ep/DrQ8Ihsew==
X-CSE-MsgGUID: SoQl4P4DSUSMkK54tThtOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,151,1728975600"; 
   d="scan'208";a="88072166"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 11:04:29 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 11:04:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 11:04:07 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 11:04:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwg6bvmvszHum5vWEA8WHXVbgUxtDXQkb3PVfKh/GSDOj3bUf1p8oDt5LllPgs7HsUuYT647FVX9AyhmZaYq80VmLy6mvtvuYM0+2sHd8ae4uBA8IBEOkqsouIHaD+MS20iByDbSsrRZmN+ahGvuIU9OMttbNhIz/SDSYGWe1GJsJRGRvJ24bqnRVEiQzTafTtobylxI0sqMiFhpKA+EVMPqwfe1pEpdP51k/N6jH26xqw1vgIJuucRAgUTxwxIx2Ri9uQ39TZepb4qvMPW91qFo7Tv9/PqHi8p3eBINZvZqE+5tc5OPQCP7ysnzdKjIdgdbxH6nPcPCUtTsRPINUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOr4FrUgMKSVTQi4hlxWzvF7O1239UYgqOMCWD+L0YA=;
 b=QWsB3Lyrr3BimhFhxLcQP15+r5wvHMpcb7lm2eJXKGxKlsgHOTh9ZtxC8v8zY9b2L9sDsBVG9KrKCph0kWOntw40i3Off3EnHRNk4eX6gm5jtSpme2mAKdSpf+pjLdhDfoJ+E9V2MrTY/X/cYgR5YyhFfe31HIxn0Qse/v+5zvW9dHwwLnUzBvbhM+bEtMzF2FpMAM57ODCXQSI6Kcbrt4Lv4NfV7ZDKlvye+OYTA1cB2yAiJbM/K/twwYi/LhhaWkgFa1j9w+F1XntBPUsxSPhGJr3AFdSvn/GmsoPSESIUIEoNbls/d+hmT0ilUDg7aU+BchNnHG6NYEHrYIqxjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by BL1PR11MB6027.namprd11.prod.outlook.com (2603:10b6:208:392::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 19:04:04 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 19:04:02 +0000
Date: Wed, 13 Nov 2024 13:03:58 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Keith Busch <kbusch@meta.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] btt: fix block integrity
Message-ID: <6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>
References: <20240830204255.4130362-1-kbusch@meta.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240830204255.4130362-1-kbusch@meta.com>
X-ClientProxiedBy: MW4PR04CA0337.namprd04.prod.outlook.com
 (2603:10b6:303:8a::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|BL1PR11MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 50421441-dace-4f07-b9e9-08dd0415ef8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?e2TMsImyrm5LKGeIWifHQ8tU0uGiIoTeCEFEb3OeGWEM+7BbpeZhJdrw8LYL?=
 =?us-ascii?Q?addpbR8jsfKyEdEQxdCv7YLxRRSb8Yn+/JVUOBaU8dIcID62tnH2jRjUoG4D?=
 =?us-ascii?Q?ZetRjw9sdByS9LHKYyXbhm/QRButtIQtr8aS7Eto9SULAGhwuDbKUTCgurIV?=
 =?us-ascii?Q?GQ1VM3uhBMn7ctMHVug1q1xuLOqqwY+0MZdAPiyxbxa/YLxoo+R5LMukKarm?=
 =?us-ascii?Q?gY3LVzEfE9UO4D5svow8qZ+lYu2LUXBuKXuHPMP22T/elgDXU4jlq3S6WfAg?=
 =?us-ascii?Q?O90N4uMdE+axHyO90dn4ptON69Yqld+Am+at0/n1CwvLGM9dGEFMPhHuX6pB?=
 =?us-ascii?Q?VhVS9AKvm6Izl07MtbK+WAENaiFESUKxq4Ze/gxZuuI+UVmOglwTZqpcjZYg?=
 =?us-ascii?Q?aA4mWyhJcTNhOPle3D+lF6yGJNvKVs3Fdz3Y1aJ8scA4/F09UNTe3XdNB0MC?=
 =?us-ascii?Q?AYUy24jdCnIaNh0R+Yhe8TYn5zbZEL9V+yq3sQhFPL49LaGf4uoa+ytTU/wC?=
 =?us-ascii?Q?RJYNZMBj7gUCcWcCSPiwU5grA8ubGO6wQxM/xczqd4q9DCgIxIHmgrxTsYd9?=
 =?us-ascii?Q?y69m4aCmuHzWMdxWbeOeXW8OU4tN+hkpnxI3NO+L7abZcTN4AQs3mgYXWRcF?=
 =?us-ascii?Q?IFv9wpDVt2PhXV2cdq3/b87JF0+aWlhkc0Q7+E4P7NL/8hi+8ucthzhgSkHB?=
 =?us-ascii?Q?uJYv5zDaIH5xFdyZ2zs25ZhC+a7PxH2JcQzKEbCMoT24jxEX0nRkxMNmOfdq?=
 =?us-ascii?Q?ZIH5FHMXUkDEpuySqHMfjLPCuAJpExFfI1tyQzdVUCmMyi8akxQYTRLcNwey?=
 =?us-ascii?Q?VFPl7ueAeJfHUkrKa6GMp3oBySOjbDEhz2slMx/WhmTDrdA+KjXPxfgpU+6k?=
 =?us-ascii?Q?o2aONtVZwTByE0LWVykR2OKc8FQ60vNIpIbDQWfSnnoZEgCFPbmiv2sKvHRY?=
 =?us-ascii?Q?NFrXf4X8jLyG3LW5umC6GRriZ7lh3W6pAzF459IF2sBodd2njQIZeWpE3Ujv?=
 =?us-ascii?Q?GdTFJB0d39u5MssG/A09sylrIbLCUhebQjxeu4nxlYE9pm44iqTLIIDzO/kN?=
 =?us-ascii?Q?rDQ5h1KYX7UgcZmgo3yxEltivhTqpXTxtRbyf4idktK6UU9mC/qF9MmdtKaZ?=
 =?us-ascii?Q?ntX0XNx5wJX/kGvPMsKxn7ZGRopoNc0b5ioWy2GQFmzamXFTMejksHdjoJbR?=
 =?us-ascii?Q?l3LZURah5XB9cZU+xDkO1InuOpWMJ9waVsBsnxfuGG+r6uLse4fe1sefpOMV?=
 =?us-ascii?Q?Pr7+KCaJzlDjbADimP2e3PrWCsputqz6Ql3PZ17dDfoeSo5zdav5z7PgFoGp?=
 =?us-ascii?Q?MNq+FCITPc9XQXH1+FepPClP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+F+qvFS/TYJKSRKDBaeEs04R+Zn2+wJ+horpqaCN8FRVe9TsGigYlTW6YK0U?=
 =?us-ascii?Q?/6jw2/TD+ycxPHgHrf5CHGf9lIE/ebeTa9YiqqfZAHYIAqMgHCkTVPQ5rwyY?=
 =?us-ascii?Q?oa5XWkBf+lMWf4wZHCPSpJYSBE7w95SUBMIi8bMMmZ8CSK6bahwdfS9fpJhj?=
 =?us-ascii?Q?FSSXcZ4lHw7PBEZDqaYgA4SazGq/+9hJyVfU6dvyS9cwF+Gc5MKKrHYVMB75?=
 =?us-ascii?Q?M7mHDJbT6WPIwOHMzNbXCa5jkMkAw9wtE3/ZdHVhYkj9wrYPSzbWj7UE3nCb?=
 =?us-ascii?Q?hLZ/4gHJ/ByKzTBj+csVgctKs612EicJ7PAR9L/BRi4vVwkCJT0AbVryMCBf?=
 =?us-ascii?Q?8kQDri1fTzPDp3E/7719IVcx0E3IE3hoESdmNbKyeGAQ3GantXyltwqLNPfA?=
 =?us-ascii?Q?6Aco94RYOPnnJVfEh+9xDruVXyviQiqN7b+i9TEP4RWAY9QeK6LTfIjnzMDb?=
 =?us-ascii?Q?vbLvqPUQ/ucuZa2tjQwK3bGGKLADYI/KsmltvH6pcf3PwYDcfgcPHUYK22DY?=
 =?us-ascii?Q?YgERJWWMFkeyQW6up+ATb4/f3mnWTGe9dMUd8lvTyPhMKKiIYriRGR7MeO7j?=
 =?us-ascii?Q?hubWMzLW5lurdHFhNDVz3QiVIdCWKd5csCH6M8oKNxF3vTA7e8LjtseMnDvQ?=
 =?us-ascii?Q?H/I14udLrPs/SaCtz8ueIlv9wwy54xkPoaQz/SIgjzjZPA3xKSS6T6n0BT+G?=
 =?us-ascii?Q?89QE1VUGV9LTdtmFJ/QRzunsTScwEvXwsL8Y5jUqkV+dxFhzo0tCZzYPuuks?=
 =?us-ascii?Q?geQ4Ocwhbghbys3jrwqN0G3+roojcVtf1WOaoPKElzk6c9bWPmZRplINYquj?=
 =?us-ascii?Q?16JEFSomWkKBIeLcU+Fnb3rMiVedoC2nHLtr/UnCIXnPb7B1zeudsyufTRON?=
 =?us-ascii?Q?1fx6oxPEXE2FLIEr1VD+muAdzNGrEMQXKmWVo1vGD95SOJwyRIw8JxsTcazT?=
 =?us-ascii?Q?WngDDeyLJhasJDpt+VZXqZZPYD0z0BhGzwu28T0SddSNMceeMpIDPWGWtlKx?=
 =?us-ascii?Q?FraeD9lwpC48w9/cfuBtFcG9UHIpH2YT/WJNwYN5mnODMPyeQ6HX9/56q6DJ?=
 =?us-ascii?Q?jhSg2tws+Vfw2ZZC9Rlw80+qaU+JJtwbl0zKGwLXe5OqVpJIWDBjYhR1LNHJ?=
 =?us-ascii?Q?sBAW6GMA1vD9X0L2DbfpuWqp2Pg8O9St9jwKvykwPHZd6WmohfMKX7qzpFGh?=
 =?us-ascii?Q?klO2fgp7RzHvKQukblwPymORhdd/PenY285bigvZSSQUWJ8ldQRdc7ZOxUfH?=
 =?us-ascii?Q?8+81eDsZ8ftbLvrAi+e9X3NZ23ojSqQn23cXCuY1upmHG93jYNrk/lPKncUx?=
 =?us-ascii?Q?bEqaZ0hPlhRYTX5EiL/zwVuYGlGg8b28KmGqwknuvlawLIQaUTYf+HY1hTWx?=
 =?us-ascii?Q?8HcIHLxD4ujAkxxeluEdZXw2Kdl94pARFWJQHL3Q7U9BDtGFDB653Uy3s9jm?=
 =?us-ascii?Q?oy2kE8ZSt7p8C3x6Vgp42diXU+AS4Rpx38PSK2ukACEt3SKcH3j4DIROoHRa?=
 =?us-ascii?Q?jSQvEbvhp/2MOwId6MkFRI9DVQP+NqmllZ4i4XBlwtNWrnPHDA32lYkliH/c?=
 =?us-ascii?Q?GpGSS+eO/FG4UxYsa9Hfo+C5PuPuoRj2ZoUM2FRc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50421441-dace-4f07-b9e9-08dd0415ef8d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 19:04:02.4509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oN0a7J8vKnX/l/NVQwRJD83SEnUqcmdgBj5DgU49lexHgcrCJYCgFXAudUcdTvSwnIOB02dmU32z+GtkDSqz0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6027
X-OriginatorOrg: intel.com

Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> bip is NULL before bio_integrity_prep().

Did this fail in some way the user might see?  How was this found?

I think the code is correct but should this be backported to stable or
anything?

Ira

> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/nvdimm/btt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 423dcd1909061..13594fb712186 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1435,8 +1435,8 @@ static int btt_do_bvec(struct btt *btt, struct bio_integrity_payload *bip,
>  
>  static void btt_submit_bio(struct bio *bio)
>  {
> -	struct bio_integrity_payload *bip = bio_integrity(bio);
>  	struct btt *btt = bio->bi_bdev->bd_disk->private_data;
> +	struct bio_integrity_payload *bip;
>  	struct bvec_iter iter;
>  	unsigned long start;
>  	struct bio_vec bvec;
> @@ -1445,6 +1445,7 @@ static void btt_submit_bio(struct bio *bio)
>  
>  	if (!bio_integrity_prep(bio))
>  		return;
> +	bip = bio_integrity(bio);
>  
>  	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
>  	if (do_acct)
> -- 
> 2.43.5
> 
> 


