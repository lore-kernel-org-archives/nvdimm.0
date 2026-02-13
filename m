Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1101B7F4
	for <nvdimm@lists.linux.dev>; Fri, 13 Feb 2026 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770941556; cv=fail; b=ojxefvOfGnscHZtXhmVV/oD6Vz80P6cBzPe1ohmZclVynVariw08XaGOxRz+WMc1YsYlGyDaMydmcfs3XljUI/5Y3UczqrWQWqKiC3gsTZZJ2NPK8yNR2c6zMHRmNzvvj23Nr3RDdkzy/E2KazTp5Uad09us1HE7fRUHPNN4HAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770941556; c=relaxed/simple;
	bh=52l8QtGmIkaV+4Y1KzG/3mqShy6fKOeji6fulI07Dyc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=geUJ+lg76CcTeees8JK/oxeqH308uAzXPK3iRQVQ8dlorf/KVURQu5oJ5SPu6Ae4O6XBnphuXgjMqJZcdTr9tT28SnKA/11nWP4bxcb/OawQZtSL3xRzMAr+TTwarnChNqBUK6p+v9YnTnKswM4g4ChMemqH3rwjvOH0uLG74FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W0AFEU7k; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W0AFEU7k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770941555; x=1802477555;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=52l8QtGmIkaV+4Y1KzG/3mqShy6fKOeji6fulI07Dyc=;
  b=W0AFEU7kc+GARbtp1746ntMe4IMzFUEoQ0HRIutfAwQyM2LA6CL+WFW7
   5BvIC63F4Wwc7KL0pfuzOE8pHDHkoeAgtO9mfs7YzLgwlxWBp+5IMiDzb
   LzsQvEfQ2bc/lGL9C7DI8S1jOodaVfa/WFJ+v20be28Hj8YulyyaMZTvp
   0MaCqO3uDUGmCEkpnXf5WqNBrfn49/GY1cm/exkLVlRxQnLSYkkEnTmuM
   CFxzo2def8ASGuHfO6kIcpf8yzcUCvWbZvEQMuouaPlLG6m7eZO/Uyn/s
   y9LMPHQSMVikDLPWux0X6xbiO3i5MNFU1oC3RksCqUbzKKPvp3ZeBGxS9
   A==;
X-CSE-ConnectionGUID: n8RsQ3d7S4iWf1i8uCPSwg==
X-CSE-MsgGUID: Z2ga/SAtS4ueknoemdk4+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72032622"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72032622"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 16:12:35 -0800
X-CSE-ConnectionGUID: KQ/iI8diSXqDoSN+/P7FVA==
X-CSE-MsgGUID: iVQYogevRPeo1TecE7Pxjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="250441283"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 16:12:32 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 16:12:32 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 16:12:32 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 16:12:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZJVYYRXRlwzdLqo99FqmQCTcyQle1mGiVnfFq9x8i6jfz43gqLiQm5xQ3WEjzwooqMf6h/44YnQZiT3x6gifk8z47UBhWN/kcJKWG7ZwUkhdvyT/FNBXwepvFqZ/r3cbyCEERRaovVe4DJnJBod1RYnCrv65gVKugkUCvwV1m9Zdtg8vRkJcpqr8LCB5+bl1rjkXm295HMbGooA3cm2e+curqZMLeuzftsNSuEg64OXIF+HwERWHRa7WKNcaiQwRekd4HowOLf3tVNoZpXQqU/TVtGKUy58I9CCxhOHB5GK7JUvylDLQnT8CkJU9Sr6HTzY1WaXmiTqta3e6FmJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMeCMKH/f+Tyysf70bACENGwj8LNXyqExQtx5CRYbUE=;
 b=pd1CdcjuvC0du4qGXzbD2IFNVxDX/myHPX/H4BW2TSe4HDSgBuqcAKTzlhkg2+MDLwcGgmrx12AyxZhuG43Rx0yVPvSQYyyY75xwSyLOZ8VeOumoeFxC7Fl9RotC5KGcHhd2JZAKOX/zLehOtTglWWyXWep6mYpBEnQZlgjAQ7w4oeEsiEcd++cClgim88svBde/cEgbXa7dLik0XCLLOy9yB6rPaVdZaNG399SR0e38oBiJ7S8h/DSzmWNA/PsCsZGxXSQB9hUK9V9dSl0StSWA0t17uZNV8vvNjn1jmA0MRILGQJCzTJOL4yLDPDkVoRXyrinISumd53K/YIVI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB8803.namprd11.prod.outlook.com (2603:10b6:208:59a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Fri, 13 Feb
 2026 00:12:28 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::b437:3b5f:e6c1:3d13]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::b437:3b5f:e6c1:3d13%6]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 00:12:28 +0000
Date: Thu, 12 Feb 2026 16:12:24 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v8 0/7] Add error injection support
Message-ID: <aY5saAx5BOJ5jSyw@aschofie-mobl2.lan>
References: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB8803:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c7ae34e-1ab7-4b69-fd57-08de6a9492a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gTQJ3tW73Q616LoQQ8gG2+fy42X8HwL/JlO71ZyUdJTmxztDfiOHY8t+1V2K?=
 =?us-ascii?Q?c5EWDFMXN0s2zWT+eJ1p6wV1IVMbeuzG82+QcO7o6V07v5lR0cKLA6yaDvnW?=
 =?us-ascii?Q?AKcW1CSyVa0/MQVfq5khrKK+ne9hK7qLesYtYSqErNaStwDH0t0spW4oVpCL?=
 =?us-ascii?Q?poNxItDeCqKxoP9RFLLaHcG8rxR1/CEVBLN3AaKH8nD/Gz6sVokpuka480NZ?=
 =?us-ascii?Q?GcD81Md03rLcPNK+u08elYFt09MS37j+EtTkuG1p3YPDDdD8NNXKLj9wyppY?=
 =?us-ascii?Q?xEKNzma6Lok8ywWAJ0zzuwjk5fSaXWklbVfRcUjCJsihVea9RyzhwLDTP0Be?=
 =?us-ascii?Q?lyluCNseWJn8eAvYdEz6W7WkbrN8iTa8NYy6jKcB2r+6Rx6VptFeef17gBwX?=
 =?us-ascii?Q?0X8V1arlCra03l3vJigQR12LpdzMFVo7dor14koeMCRfA4UOGEtlNlaSUfCx?=
 =?us-ascii?Q?ZyZ94PRWQEJUUPH/Fo6lEidTjbtv5Qnu12H83jndMKz0u+OedC6ETniomyDS?=
 =?us-ascii?Q?MjVZLvoklgv0oBK3G9du+EDrsKjJ7aWqWabGpWaZ/bo+BC1OjvGLBe1ml2aO?=
 =?us-ascii?Q?AEl55cC9bcqOJG41Y/QWCk70d9MRnAF0+x1Vk9/sYNLGlVwZR5a6OIlGakAM?=
 =?us-ascii?Q?nxv1oRuPkWoDpO2h1bk67BNtSTxRJEmINQexAQraWjcYr1eLG/ZKpnoxrqRh?=
 =?us-ascii?Q?EH3YrcdZTtqFZv6xwHkyNZEupUBEh/Gx18qWHDzM15FBuzkMVnoiox1tVj1J?=
 =?us-ascii?Q?O3R6S8Pbzlb9rZ4K+1BzSE+WmT/mGO/9FHDRkERezPAt/ELzQzjqt5ei1XN1?=
 =?us-ascii?Q?miVymQKxErBkj7i9GeTt24Oc341wuiqxZYeDlHrZEoIEUgM4OlMbC/dlu0E1?=
 =?us-ascii?Q?AGWdDzpIUUc3wL4nJ9/vvgfCrqiFUNzUd9b2VecZVTpFjW9ONI3iJdmL/v8h?=
 =?us-ascii?Q?ZxrnNP5OZVzpXMM0R49uq5i83OGtnKGhG/nttrGpdr1xQ8zgFf93xEuWeghD?=
 =?us-ascii?Q?cORX+5pndQ0AAY4lJpGsUW294bC4ZlEwW/k+FN5FdXtnwfJIfs8MEbJoud4V?=
 =?us-ascii?Q?hOT1C8CSnU/DPekuV8ZaB3GfsmKSMVpabbtR63IlcSwXGLwXm92qtQzm5i9y?=
 =?us-ascii?Q?G1ngEey7kAzt2M+hWqT2kx64V5rotV3yWnw6rA695o89zDhxcX/KcVo/+LeO?=
 =?us-ascii?Q?ZdTisQCzEyaxEJpbZnwUU+EZbw6pzBs4MpUSrE3AMc8iQ2YS/MEYmmu2CkRx?=
 =?us-ascii?Q?/MC2X5pJ4/DApmaY5SnYIsATpLYRjMbCYEPP2nLFYj1UOzal2ZpSN9ye7cH3?=
 =?us-ascii?Q?1OnwSZfaoveZr3JdKECqy/gDliKf5gyc+ppq01PDnxpvTivxorRxwm1UAr7j?=
 =?us-ascii?Q?W5rq9Nc/kzR7OCv3NpaZV7fM1PeGXTciqV3B4n1+MT7HrNqluRd2MTiE0/NS?=
 =?us-ascii?Q?yKTAX4/f/0H4eyt85Av2DxdtwmzLbmm0RhmSjtFBmzyVO1Xit7olqmgsmCwA?=
 =?us-ascii?Q?sbYtSwg6aWtaPtY1KaZLpR8sv1ROxeCstzkoHtINBXw6ghUGM6PmwlVk5hXO?=
 =?us-ascii?Q?5Tx05RUZBUJydttGVK4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dPxTxiAKQtx2aBD3fBqCaxY/hrWug+hiKssXoNSJTbFzs/Mfw7AZak+AgPuT?=
 =?us-ascii?Q?HQTYkmAQD7wsybD9Kd6XYPPrNsXDdWbGK1RIPz//3xnSPSFCP90ye0NQS3Hm?=
 =?us-ascii?Q?czSpit824RIk50fY6o8K7aQuwNPFC1+lcStDb+LAvBJ4I702VFsKjbyiO5L/?=
 =?us-ascii?Q?NHFBA2WJoGeTCuUf1q40iKOGBiQqpfxDy8CIjwHD4H2a4RZkbNuv7A8vQaGa?=
 =?us-ascii?Q?FbEWpEXdoyOo5P1OF61dYc7h3laGep+FOsxpYr/sdANANIorW8wBISDh3P0T?=
 =?us-ascii?Q?1Gh3+dAgFLWqO8Dpe3Xg4NbNSGRKPIE3cZpvkjvPJsr4HbcihSvEIJkLnKtZ?=
 =?us-ascii?Q?wYEh7lA/8hv9jswND52YaZVWIVbu6SEDTXdxiFZdvaaPbD/c6382ytSjlNIb?=
 =?us-ascii?Q?GTTBIxI0wul0m9yPPwoYf97joU4Mn/vgcymCC6ews6pus67ZS9+0Y/aNKNEw?=
 =?us-ascii?Q?OgFM7WPdkmvinBR8AErIvFxQsp4OB6UHIpYJ8BesZT8sqfCCONhBDu+AsqnL?=
 =?us-ascii?Q?Fwf66W3y7Lnj/xcIuvkJFBmPh7ifSO5UEnAPut/FbVBvHM2qcZZ4/uI7iLg1?=
 =?us-ascii?Q?2z9OxVDLtNORFzFK5wHVTV7DoEH7vC3W9L3ezh5lwQXVW+/UjtcCFifn3gsc?=
 =?us-ascii?Q?nmY3amCztpC+XeTPy1oru1RVV2eyr3L8eKtLJ+vloESwk+Topv4gYTv2XbdA?=
 =?us-ascii?Q?43nKmxZ5SenwLzg2ww2psERYl/XV3taB4QYApPrd5ieKGyEhCK6IN5O+Rflp?=
 =?us-ascii?Q?bv9ZKEIMjHt1nqRsd2oH1cAi0RcJA8d0cAh/BcfIay3JcqXl0DAfgYTDyHqg?=
 =?us-ascii?Q?XVP4+aNN9zXt0eqSmUqK2Cru7C8bvz0TDF0xef+hr1zfDPcv1U1u90qe+U7H?=
 =?us-ascii?Q?MjeQnxheMoixh1NpimwdSP+ixyyPrKCYZlELhUCSlzXTWv8lQZtdjQrtU19f?=
 =?us-ascii?Q?5Wja/owJAE11bSl4CGus1jcJU1DdwJJafsDy4UUnE2S24UogUcSJh8o3lUxv?=
 =?us-ascii?Q?CvVJtujyEc0SaGYkeXlvPmfQC1T5ue7n2F9h1QpWt+9GBJWcPYxwwVszyqzN?=
 =?us-ascii?Q?c0JzU2gX9OUHu+yW7IgXNrUA9VBBDo1mxyWsDVZyAFROzqsD2ghJOvT2y9Jp?=
 =?us-ascii?Q?K8sp+3HuM2EuCnZcKrlLHis5zdc4TimadJ3ep7ZDPhCdUt1w5nHniHXs1l2b?=
 =?us-ascii?Q?Z+YuGiXu6WniP5hZOcaC1eKmny2XGZn9GdU/clXzKUE8TVDpDn3MAfuiNIW2?=
 =?us-ascii?Q?2QXSSEWrPf2/BtillJvPTVbpi585un3sAVVDZDW0iQ7wQSbeJBeAfF1Br+KE?=
 =?us-ascii?Q?ykfRhBS3vVxvvtv5b102sUi1bVMzoBqkXLK0ThTlzOV2D5tbCKSRrTCHCQ9Z?=
 =?us-ascii?Q?d/vipZOGqls0LeWdO8quh0rBHJDhxfXo1NkStakjckmL2sPjshGULcAfewm1?=
 =?us-ascii?Q?FKO7SIPZxgFbc4rYAHIoxd0wsm2IuWKikcUWidyCtSTmFG7U3kUeWWixw5A5?=
 =?us-ascii?Q?B0/SvD8vECBwsm1JN9dWsXCQ5Mw3nwEpWPs7abRhi0cN5Y0b7EbXHZHnDSWg?=
 =?us-ascii?Q?E7qJF9mapnqDtj7WsAxU5wvCwSgvOFkDYlzLdGX/oROGVvojD6ZLg5yuFWVW?=
 =?us-ascii?Q?mDskpt+U+olrulZGx/Gly3pl5REsf535EXLZqXn3Kic1dduJX5Lzgq1gEBwa?=
 =?us-ascii?Q?zzRhxazN6ouCSJHnxTWIB2KcfsNva8xBe4JgTLq68Dwf86QQgis9yBidH0+O?=
 =?us-ascii?Q?Qd0a+strVob5cdJOX1UjBEzQ7zTu0Mc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7ae34e-1ab7-4b69-fd57-08de6a9492a8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 00:12:28.3446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oofyPeaJhJYjqPaW5iDjdhcC5OS5/SRcE941hKWZJissgzYIZyO8A9JCp7pxP5naWnSfSkZCzdEmMQaIunL4UP92F5o7W1RzgjR+huO8/WI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8803
X-OriginatorOrg: intel.com

On Fri, Feb 06, 2026 at 03:50:01PM -0600, Ben Cheatham wrote:

snip
> 
> Ben Cheatham (7):
>   libcxl: Add debugfs path to CXL context
>   libcxl: Add CXL protocol errors
>   libcxl: Add poison injection support
>   cxl: Add inject-protocol-error command
>   cxl: Add poison injection/clear commands
>   cxl/list: Add injectable errors in output
>   Documentation: Add docs for protocol and poison injection commands

Hi Ben,

Same concern touches 2 patches, so commenting here:
	libcxl: Add CXL protocol errors
	cxl/list: Add injectable errors in output

I'm seeing some unwanted complaining with cxl list when protocol inject
is not supported. Here is a sample:

# cxl list -P -v
libcxl: cxl_add_protocol_errors: failed to access /sys/kernel/debug/cxl/einj_types: No such file or directory
libcxl: cxl_dport_get_einj_path: failed to access /sys/kernel/debug/cxl/cxl_host_bridge.0/einj_inject: No such file or directory
libcxl: cxl_dport_get_einj_path: failed to access /sys/kernel/debug/cxl/cxl_root_port.0/einj_inject: No such file or directory
libcxl: cxl_dport_get_einj_path: failed to access /sys/kernel/debug/cxl/cxl_switch_dport.0/einj_inject: No such file or directory

I believe it is not an error for the path not to exist. With the device poison,
you already treat search for debugfs file as an existence test and no
error is emitted on failure to find. 

If the diff below works for you, and nothing else comes up, I can fix it up
when merging. Let me know -

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index d86884bc2de1..5e8deb6e297b 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3496,10 +3496,8 @@ static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
        }
 
        rc = access(path, F_OK);
-       if (rc) {
-               err(ctx, "failed to access %s: %s\n", path, strerror(errno));
+       if (rc)
                goto err;
-       }
 
        rc = sysfs_read_attr(ctx, path, buf);
        if (rc) {
@@ -3593,7 +3591,6 @@ CXL_EXPORT char *cxl_dport_get_einj_path(struct cxl_dport *dport)
 
        rc = access(path, F_OK);
        if (rc) {
-               err(ctx, "failed to access %s: %s\n", path, strerror(errno));
                free(path);
                return NULL;
        }

