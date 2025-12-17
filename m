Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF63218E91
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 04:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765946381; cv=fail; b=TULyBZ+008FPYhxVtYRrAH+VIikCvDy2F5tBUopbWmJKjDq1i0CO6MvANUY3lss7uepFowgopBxfkkm9h2lNfznPCgtuypHWVQJiNoBDE7WWQHdgVjStbrxwot4RH9UmqNjvj3bVIdu+UcebZa9L8VEFEBVesqr5hUgr6LKZ4cM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765946381; c=relaxed/simple;
	bh=PhB0OAQOxCEbm0VughJZjkpA34cUg9AjDvdlKgQSKd0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MEJCQe6jdRCHhjqvTMSeOBjt0eopIKd5dI+uiOTvgnoo2jpfqMuy8bZvBXkaRklXT0iukc3mpBZ20p2uD61JJaEW81lZaFrZagwT3sUaSQBnpon7jKSAhZPkAJPhJyGxeAdj6VCfSyNRVX3nDRWI1EjJu3fK8pSGHfSd1qSb/Xo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NKNMfobJ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NKNMfobJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765946381; x=1797482381;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PhB0OAQOxCEbm0VughJZjkpA34cUg9AjDvdlKgQSKd0=;
  b=NKNMfobJsWH4FCiNlsz5Yh5zT3Uj6l9F/qR+Zrb2vsmo81Uwsv67yw64
   q4ft8YQEOn7cpbECnC9YVjG7Hfmf36+lHk9WUuXM2t6xdApULOuhYDaoT
   esaev0S+6WCr4ceTJnqNuhR9YWjUPRufklsPaCi+k45ZMUM098fCLbqNj
   T05igl1uVUyIZKzgplebIL7sbfXs+TZ6H2+eUXUHQsim3P/LWNx71UF/1
   Naz/MCLreNafBbkcgdmETBU4If1BCx8UD7mpdGmRl9gi3jpXtq/AQ/Uh+
   s2INgRtoT33/Wj9r2IB0z+c5AnqEE3UYmYlGnhO2lODMmDNfZeh9Z9BlA
   g==;
X-CSE-ConnectionGUID: Gdx8DvZwTUStGi2ZNWF19A==
X-CSE-MsgGUID: xsRw3/TCQ1ese8ML23Ebyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="68032097"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="68032097"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:39:40 -0800
X-CSE-ConnectionGUID: x2Bk6ofxR627WjxQ+6R6bw==
X-CSE-MsgGUID: T3kCigfRQqafp6lvV4AloA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="202696897"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 20:39:40 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:39:39 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 20:39:39 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.14) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 20:39:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fC8e+ryRBSx/MOlWaUjRx8N0Jq2DUSdSzOa7t1gs67LdGXEQCUSKZLznBoF1lDs8wJrk1jMsdsQKovWq5SyR0t0J1S8A/6HE08AXyBQjqIXZ7hgkmvIjypQwAHnht9ld/0pVmP6VodlSob/Px0Dmb7bNcDmIUVoIDQmALWtbxJQSSVhdhPH13YuNNO0M2m2g+HbVCC1lZT11pYlBePoIYb6hysAVdvVRqft3QkjQTBgMbn5HNCcobBsawlTBgwzSCxWwl33J+Wdh+ldbHbTA7uS75hwJNaZVdmwlQyWYyWTV/O3S6vvSN+Od22Bu9P9koWoAe/d9LR0pwQnkS62O5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNMFTJJp2XL9P0rkPHadsV+ZvU5MKyY2mg4T7kS6TdM=;
 b=IknjB7mfWl62mV9NnZJPfRpNAFPOc1gar2KFUb7br3Y55BJkzm/EPn0Z/7R2lN5b7TwbGkXjLlqHsgligMlpAAzAg8AyEJsoP5LLvmYz80uNewxkFJ9zvEqRVaDyCyB/xWpnfTmN2n1CGI/IqxDJNMfoOneugDY+VRFKZqeRoq0Ncuz9hxyj9BAm/K8I1IY4com4ZN4POIMg2akIInPh/+2dVH8XGgpYdYoEB7w16LqRIRm5LtAhXoGrKuVuxKdgb8OqLPmS3kYgI2re07QqTlPLd14bbXTvLGK1/ybzxMkblfMDLC8XrQjRjdYt1LU5niMFY9UPFlx94QakjTRftg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Wed, 17 Dec 2025 04:39:32 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 04:39:32 +0000
Date: Tue, 16 Dec 2025 20:39:28 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [PATCH v5 5/7] cxl: Add clear-error command
Message-ID: <aUI0AEkt5BpNEq0T@aschofie-mobl2.lan>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-6-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215213630.8983-6-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: BYAPR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::19) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aee3594-b9ed-4c70-8d44-08de3d2645e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?btmNIEGSWOu8IZ8wuhWXl+EGPNuedunOOj5luwvjXZ/4M4hRBE6i2DkeJC8k?=
 =?us-ascii?Q?b9KxBPC1rtqP7AWWuPLnA30SGqQxhVtX61pKUa3tNNPl90dFXag8muGH2ORy?=
 =?us-ascii?Q?sKd5cdgec+j5sTcctHsNikcx6rS61lIhpIfLGTpoUrTMmqqCa8gF/4FQ/URY?=
 =?us-ascii?Q?dprzUotRyhUE/WVpkKF35PVKoxRm1Fqp1EffkJwhELUeij2PgVrj0r8aphMo?=
 =?us-ascii?Q?soKK+M8gfof9ZszTPV0NVWoX/TTV6NHiK76ZpZlhjnFlPHisozOfNgURcsFi?=
 =?us-ascii?Q?XACPa+PQC34R5nkYTNY54I4JYZfCoKA+qKF8twTmK5bVzYUa1hlARSTHMu/T?=
 =?us-ascii?Q?/TauWAs/1pwyF2Q4rr5UVi0+S0YeW6GpN3EK343ZcMnFhA0D30Qqg5qv3G6K?=
 =?us-ascii?Q?l3bJxheeVYN9GVi9MNNaG7oRqkn8ZwRMKcjrukaWXLkSrW1tCnD6haWMwi6s?=
 =?us-ascii?Q?8/1IP0j1piXjplOR8/SYMYbs97ZLE9JKMvr+7FD7BmSUwDaeXSYdgrfZazxv?=
 =?us-ascii?Q?RwAZxGhovvKlRmvIgIbz8LuvgkFZNH0YHPn4Y5dsLvQt501Tk4S8byeONPst?=
 =?us-ascii?Q?TQUws1FRET+f0IBKGtvr611qf0Kei4wF2FDHvui8X6XbR09kCwSV52ijNZVo?=
 =?us-ascii?Q?/PODAWD/biEeIdO539nnakjGJtRySM17wavIKdNGXrGaCaumOiuTg4bjhsHv?=
 =?us-ascii?Q?fUYjcCAOQPeF/WMzIFG5wpD5MOWCwPb5nu2d8sb7TppBLNHrxrRqWLKf9gLX?=
 =?us-ascii?Q?+NW58lhXgbFKXChtBJBWY9cHMvgFEoxW/qRRocJgHKNUiJtGuckWIR3qJEn8?=
 =?us-ascii?Q?X5iImlV9cFZeWq4rbUR7conmmFH0fITAXds/siGV1JzjbHapY0uNUHSxkM2d?=
 =?us-ascii?Q?k53MopYdEF9i8VrcDqDzvAeTs+TvniYWV8P037fYh+9zF8ixbBut8CzapNw/?=
 =?us-ascii?Q?1x2nJPfUeSiDQXdCIRmS8zl/joUUOliLvlMcBNfG7rV7oljDAGgWL4vXuh10?=
 =?us-ascii?Q?qo0e3mcXFEjucWPdzvz5pvzd48bTdnwbTLF6yYAINxdU8X59KgtZ1VKbqh93?=
 =?us-ascii?Q?bqtwARPSkTg+81AtB4hQUxSFTyA0FNO42Y7oMe+bLSeuHcZTFc6fszlH7eCW?=
 =?us-ascii?Q?0OZQNom2k65dO8gbUGUTVWNsdrgr71/gbIyJFt4i8wev+pWwTnjA8ff929pJ?=
 =?us-ascii?Q?4pkcp22KQW4fEO1V0LmJQgM2Oj8WgJI1o2qfp/yjXXozGjTva8AZEZCrmzWS?=
 =?us-ascii?Q?rWFoGlflVuxMfW5mzzk9wGvDcleq2qBjxgnQOzVRk7uITZyoFGuptcssSVBN?=
 =?us-ascii?Q?RpWaWybm1H2F6WU3ZO3hjpTKo6K1Bfaxj7DQas+SY2NAFSEB8sUax6M4m/11?=
 =?us-ascii?Q?TgAS3S6Y/yZhyuVqZpKdL+peq1L+tLUZzrcdVWoXSxQRZOcMToJfXWhZX5HN?=
 =?us-ascii?Q?Lrd6kzr5/CdN8uJs1bTq0lco7ogNoFlz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HVwVUCCn0Ii4+KOFpDZnhlEs/ZGDevML/ElOjxDJHjn+QiySAHGZO2RAK4Dw?=
 =?us-ascii?Q?ysHgxQ0wOl2ljsJ4sUmOom2Qahl3XNTcrR+sEfon44unSvmZAX0Tlk2HXsHO?=
 =?us-ascii?Q?EexFCtYgnC0QaVI2V4D+P7oMzRgczUmbdA46ib/0UrdmEvZNJS5wRgl1bVvl?=
 =?us-ascii?Q?eDSFPjvgN/02jy9GVPjOqZawmis+BI31cSywpjMNT80Aa6r2b0JjwenRu+Lh?=
 =?us-ascii?Q?ZzLNpLzO71T1vJ3RJ9do1ZGekK7dKzIErUNlUNl2GZhgsewXzP7gDyq5/wmA?=
 =?us-ascii?Q?YezEKclbWeo1QOhmOufODKIaW9XG91oeiRTQmV+a3aT+IuIpv1cz+NdiKYaz?=
 =?us-ascii?Q?zCsbEcVvvXFKv+QX+CFHQaj78WAjBZ48YxFU4Wc5/bgNM1hybIouskoXlj3B?=
 =?us-ascii?Q?/n+HnElknyRWrC2qgKBLazTc0k29xpFqoeswaKgJbxRqQKavlagMyEspkPfB?=
 =?us-ascii?Q?1csne1EPLEJwY4o4Wdq01VqEveCC7SOOtoq13pzehRpDFtwPUb1aPyytJZam?=
 =?us-ascii?Q?9Oumj7zGJxJXE+hg+tIc7OW2q9RJ26laN0/jmO9wks72HEG1qUng88uIdBFB?=
 =?us-ascii?Q?tiLaE1Mk3eXMzLgH4Fc84YjSaQ7aAT2XzhhZfbW8Doea53Qk2pra+F5DA6wT?=
 =?us-ascii?Q?/Uvv8seBVlho8np6ri9qOYp8PtYp1IBFThBpP5cVuxZ9svS948DDo9pF+3Wx?=
 =?us-ascii?Q?QX6FPVOPGIrK6OXmdmRjqICO1auU1lU9nAg0vB6twQEatPyeW31p4zWwg/l/?=
 =?us-ascii?Q?rw7akb5mpdRLoXU2xU049SlnLIya88TVu3I6TE1RLfBvSDxUo/lJ2BCq0kZM?=
 =?us-ascii?Q?XaN85nH7H53irZFEtd35Zodq2h8X6kdbaKoBquYgBwixUp7laxtIvWZwZXug?=
 =?us-ascii?Q?XP72cb1Mt9Ud0s52Ta4SpD3kQDKx6fKYQYx5Q9TJ5/AOQLY+C8ErpJrW12AI?=
 =?us-ascii?Q?ZGcdCG4qnzzUaNPYBrt9W7K4hT4oUWm1jEE3Xne3KdBEcseiFIYDw/iEVlZe?=
 =?us-ascii?Q?LDZwlMNg7swLSlDLiEnqfWq3UXOukp7nUHKqyxubYjtUyttvQbk9uI+YzCgV?=
 =?us-ascii?Q?cCF3anTIfnIKFekmay/6RdK/BDCT22k0N7HqDhG+bFZEmoUuRf2MAprIAe5k?=
 =?us-ascii?Q?L0BVqnWz07/HKIoQL5dbf5v5e0xuC5z1NyG/YbTkEfc6GUlupmLq0tDhN6Zp?=
 =?us-ascii?Q?uD0kJvRJagChT1t0yLQCyfJQZQRBc8KmXgUSC+3NZV0zoG1026c4KatMhgIo?=
 =?us-ascii?Q?+ip6f7gMFnDZyaxIg1XHbwijs8BcRT89HV9dGPcgjDOEwWW4AULo4cReivxl?=
 =?us-ascii?Q?oZbGVGSzxFH/Mq9ClOtc8CeOh0c7NyNjcQsql2MRpZMQd70yKH8zZ86Sxtqh?=
 =?us-ascii?Q?RZm3mJuf+QwFiZIhSI8+hTHuARTngjnI+uGxJpLOuDINcf83eiFWSls3Au9Y?=
 =?us-ascii?Q?CosIZNQCAwuHPaIuh9Y+LzksijfwlnfrH3smU1LlhZL7UvEXeHMF/vQ7oHW8?=
 =?us-ascii?Q?4DBg/lDpTfGLo6WwV9pOg2GjKbpzkCM3qaEOfkS7FHeiMIxJ81NpjfZRU2ax?=
 =?us-ascii?Q?nuX53OxyIOu/4slSTfGpj8jzhQtZSuFi72C5o+pqLeluOL/DCRCoC4kMXJxt?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aee3594-b9ed-4c70-8d44-08de3d2645e1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 04:39:32.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Il3yiHTEdjsYS65K4+A65oZCwJCZn7qPLChjTF1oWu3QgQdnoWvQDxtWs8ZZnBuM0TkdDMNuTRMYtZ6r7TNfEj1P3mNevwYnOiu03B8CPF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

On Mon, Dec 15, 2025 at 03:36:28PM -0600, Ben Cheatham wrote:

snip

>  static int poison_action(struct cxl_ctx *ctx, const char *filter,
> -			 const char *addr_str)
> +			 const char *addr_str, bool clear)
>  {
>  	struct cxl_memdev *memdev;
>  	size_t addr;
> @@ -129,12 +142,18 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
>  		return -EINVAL;
>  	}
>  
> -	rc = cxl_memdev_inject_poison(memdev, addr);
> +	if (clear)
> +		rc = cxl_memdev_clear_poison(memdev, addr);
> +	else
> +		rc = cxl_memdev_inject_poison(memdev, addr);
> +
>  	if (rc)
> -		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
> +		log_err(&iel, "failed to %s %s:%s: %s\n",
> +			clear ? "clear poison at" : "inject point at",

s/point/poison

snip

> +static int clear_action(int argc, const char **argv, struct cxl_ctx *ctx,
> +			const struct option *options, const char *usage)
> +{
> +	const char * const u[] = {
> +		usage,
> +		NULL
> +	};
> +	int rc = -EINVAL;
> +
> +	log_init(&iel, "cxl clear-error", "CXL_CLEAR_LOG");
> +	argc = parse_options(argc, argv, options, u, 0);
> +
> +	if (debug) {
> +		cxl_set_log_priority(ctx, LOG_DEBUG);
> +		iel.log_priority = LOG_DEBUG;
> +	} else {
> +		iel.log_priority = LOG_INFO;
> +	}
> +
> +	if (argc != 1) {
> +		usage_with_options(u, options);
> +		return rc;
> +	}
> +
> +	rc = poison_action(ctx, argv[0], clear_param.address, true);
> +	if (rc) {
> +		log_err(&iel, "Failed to inject poison into %s: %s\n",

s/inject/clear


> +			argv[0], strerror(-rc));
> +		return rc;
> +	}
> +
> +	return rc;
> +}

snip
