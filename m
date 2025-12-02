Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95DB2F90CD
	for <nvdimm@lists.linux.dev>; Tue,  2 Dec 2025 22:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764714183; cv=fail; b=US13dchvyEyc+mckuX4JKQsCerDgAzZedesvIItEs2QxxA9PvuqY7tgxFFXYOPfpZZxr18A6rrAW/y+fc9r7r52kfev8sS9qhhfabqC/9TbQ8UITUx4uA3NX/Qv3QopIohMzc8PsfAFBQ2wnv1m1rYYhRPXu1+xmzjc4s4UHees=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764714183; c=relaxed/simple;
	bh=NPPVjHaHiluqaGpEaUn0SvJDvT/mN5qISWtSn2cRAWU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R29wgTay+vGhuKNUdlJWcr8QxlnKEpE0mGVgeR1Lknxuxrkk5HTcYmMDbWWCarf7M96mMFlHKS9B5p81IZpdf+/5GynUZQNmd0H7CwOLVHY0uUbrO+3yRY6mQBSjT9o6z5e7waglrRURoJvbD4FEnzctd/abBzFJYaAx24rGxoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YuShZKV+; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YuShZKV+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764714182; x=1796250182;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NPPVjHaHiluqaGpEaUn0SvJDvT/mN5qISWtSn2cRAWU=;
  b=YuShZKV+8J3+ihgouYrMFpbemrU1YlEfZobMqSYyeBgbUCUcot09uoQx
   +OFm4+ze+0j/M1vuuLUKdLApvUcSLYIQzb7RONWgnqsORe86NL5jIEUTq
   KqQrvL/Hjg9b4uxzfa6D4Rhan4t2AkG88ejkAluge2H5sx3GMarPVjsrr
   QJKusHWccooDwnGSitmDbON5HpMGfGvPgR6jV87iY1A29yWqnxRZ9UYZn
   pp+CkiE/9kO12E5RK7Ja1HGDl02cL6cK85DK0RPFCgzkhQr7RCU/AN3wk
   Y0E7bwM5bPCoEHLbHFM/dWTM3DM/LB8YGK70PqUCuneUILseMPNKsGl/+
   A==;
X-CSE-ConnectionGUID: q96+XB62R4y5iM0wIUB+6Q==
X-CSE-MsgGUID: HutUnlp/QrmZx7fFzJRQIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66733944"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66733944"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:22:59 -0800
X-CSE-ConnectionGUID: 7gp/FRfjTK2c55InIRE7NQ==
X-CSE-MsgGUID: L9fjirUgT3mtOBNf5cSR8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="217846451"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 14:22:58 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:22:57 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 14:22:57 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.47) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 14:22:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5lUHalKXzUSdnoh6fb7OHezXCNpokl9xfME0Ev+2XX4vj8xDAtkUpIJjGZ51FobJ8Po6twYfwgXxQFUP+TbGasV/2FQEPlzhPqoZ1yabUCSS8gwcKYmNdFDpHNA8A0UTB2lf7+66i6tjCWsQwUfFbKoVpMTKVwb+VYbyzj8A/41ClFZJiBHnNoN3a0U8WAx4HqLceK/dHt98P3W8xeD4k9i2KMKf3lgn0+bFHpnYeknD+noxQbP04NCu0BAgK7q/lRnn+exOQuf5UKD9yFIp5W/5QitEEwMYRWmFWb6cXPRXKMdnIiG9BXkx5Z9QldwXpIkRLXDe3dD0WLgfPiDtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbaodjusnhkfCVsgNMj3fYtVsGXXw4rwAuwUcR2xehE=;
 b=AHoOjFEA8HS1BSf1we0mhgukSyMpWk030J0Xn0i8lf2G9W2hQSS/BETqyXdghYwSAHsZgcNrbgUobp6EGgieLijoHI8bC/wBzR4e/jy6g1FS0Rz12vw7SmN7Vd+eSHNTfL4p8ZvPPCcxU7rNVc/EZz34x9WRan7NMsnmZpREP5gfav6m+SBlOop+8EjuCzu5S7XrKXm7lDQ75a4HjInDqO6tLv1JLBfWkjMHjPh0CmKwJi+eiZE2FzQD7/WauhnC1zNeFj/WpKCL/EewGRp1im0I1X+ksA3bYPCFmHps3T+UvCpMT/zSVh0m2f842rQyfdO7RnfUBuGFuri4OgCJbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA3PR11MB9085.namprd11.prod.outlook.com (2603:10b6:208:574::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 22:22:56 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9388.003; Tue, 2 Dec 2025
 22:22:55 +0000
Date: Tue, 2 Dec 2025 14:22:52 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH v2 1/2] cxl/test: Add test for extended linear
 cache support
Message-ID: <aS9mvJI9FW--YF4Z@aschofie-mobl2.lan>
References: <20251121002018.4136006-1-dave.jiang@intel.com>
 <20251121002018.4136006-2-dave.jiang@intel.com>
 <aS9lExT_uyhyA8nd@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aS9lExT_uyhyA8nd@aschofie-mobl2.lan>
X-ClientProxiedBy: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA3PR11MB9085:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eae349f-6f63-448d-98b9-08de31f15785
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OCU9uSg1XzfkyBDPkp5QiQWusAJ1T8AWRYjeS8hQQjCDlOAUv+IefOYL01AI?=
 =?us-ascii?Q?9wWqsFe6MP5bYhSHsgjverF8VGbqFeF5luqIU1aRcH4Ony+ibG1uDdhn6Q6x?=
 =?us-ascii?Q?nfbYpSg1a0KiuvlE6J3uKXRpL8CPkKPY6vrPiumtgj5HcAztL3k3ZjbJXEFf?=
 =?us-ascii?Q?575UasUcHjmba9lPro5t/fMz9B5Y33nKk/GV8eBND3TxrPJ4U5sfZwXzncCp?=
 =?us-ascii?Q?lbYCks2jV2fcb08CoKL+Ue0mDbam2hasqSWfL4grwWmMEFGtOK4TRirmkXXW?=
 =?us-ascii?Q?MphAxSBxTBpgF95D5VjzdXhEHwyU72gmEEBBTRnhw38ZyZEep6Ma1/9+WLxv?=
 =?us-ascii?Q?LcPWF/o9NqbXH0AB5wwB9ckpORlwhC2ugmFfi7xUxpJrs/ckWAamocSmZ/w3?=
 =?us-ascii?Q?k8zJ0Szld12tfgqlzuKdaGldJIOskJ24Z0B8q/gyiPftoAED2e8Gh142sdhU?=
 =?us-ascii?Q?VSulbHs4ZFD6YmVquOAmp3PaK3FTbuAdwWL4069D+b3cuYRMMK/5B5jNGn19?=
 =?us-ascii?Q?vcE/vsaZiRTyyHMaN+Dtf041ZrL14R5bh9y/Wi4RoMnUN6Ksykh/LDni5uzV?=
 =?us-ascii?Q?kqjXZxMPo9TjwaLV+soSFSxAtRdBDwOqRN5437ioCBvmHx2SPKtruGuKqrmr?=
 =?us-ascii?Q?A9ynUM33NftBN3w9NV5VqGMBpRPw4m84CYByYFJF70ctkJliU+xmNHLhekSN?=
 =?us-ascii?Q?a6w69bA99qmlJDBk4ZpEMmBXWrTXiVI7noXZN04Fd5vFmCA8i8xE9glTl18R?=
 =?us-ascii?Q?7FVIw3IbQNO1J4NaJ076IVGlh0/4O3GrYrBvks7zJcMwZgfmjvqFwj551lRp?=
 =?us-ascii?Q?zYtydvpxar+KC8DEBfM5c74JmQd2GcJm1SWQQh7E2NJ3bbwYFgVfLhswAuoi?=
 =?us-ascii?Q?kQAd9PyJ+bBJXLJqKlKlPBAvyKAan1ZKWEXVfsE1iSkZNcnj1lYoGomAaslM?=
 =?us-ascii?Q?GxNZ34KF79U4mpJPD+uu50cVQHnr6fsiG737ofnBlNuPJq9dEJLVGEbrNTYK?=
 =?us-ascii?Q?yCLMvtBtMpVAXMCyXQ2BkfGUf0Mcc7fJ+osIZoMoNDYXTX4KdCsWEDSe+hCQ?=
 =?us-ascii?Q?ZcEsevzl6taEzHTba/jqCZXKz8DMKBSCCmXpELY0FQ6n4/EVyd/i1kkJMtEz?=
 =?us-ascii?Q?JnspwmcquHkmrj+9Kz23bVfoxXVhe4fp9TwlGGkZYGNAQkPPxPHptd5gt+EP?=
 =?us-ascii?Q?1EvikZVlogBUDOCxaDmUVNHcPXnz8E1OjOtYjpdSEE7Rq/Ci4Qj4VFdXtGvj?=
 =?us-ascii?Q?mTiq7wDP9gVDesToR7U5LhMnWSNMT4r+56MG0U91+MmLR8UbX1LILMtgel+0?=
 =?us-ascii?Q?FP7vH68WkXdMcbJmrgOzMVx2I9eV56u7xcJZZlDWJKUnGAzp6chLKOxG00Tx?=
 =?us-ascii?Q?KGw+KwjxTCJoyWrOTWlG/EVeyhgKGEArfEjRocihGQxXPkNG2Gg1H0wht+XW?=
 =?us-ascii?Q?yBAYKpv3Pr+O6+6UGv6ggBbndMIF1iJL0X67gSWIPBsjbTicJkzViw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3oby5ukQvz05sAlWr9VH/8ahVGx2hxbVPHVSNOTQvweyRtDrTUYuIlMBb9o?=
 =?us-ascii?Q?Wj4AzqLnIV1yWe5fDQo5AH3yc8C373fcIZoIAj9/ErV4RBWwJM1PTbpm1x+/?=
 =?us-ascii?Q?IMTc72LTP001A273oGsQpzpnfAFOd3lVXfM3FdaMpsuUr7GKXh1yy3w9vcwi?=
 =?us-ascii?Q?RjRUqKju/9tjeK+AAGhAu6XoBxdf6OemoksIftsLW3tIzdLrARr0NePs14Aj?=
 =?us-ascii?Q?Hlbk0c1xltYvae02F8eik9iEsGgfKK0A5E+CJBqhwDBYrNsCzImlr1YaCfUD?=
 =?us-ascii?Q?NPnedz+dGHf5m/OK13tDrnfLBt0lGeI5kCL9CxxYid6oOfvmQnL+zvLrLkM2?=
 =?us-ascii?Q?/tJy4K+8yQQ9qsaha6dtKGf97oEFB11zv4gqMMhZ9h2wBAqFl1Ll9TRSPhl2?=
 =?us-ascii?Q?++b+ChdSndvJPHzAL9vE1PQL17SV8MFBsZi43Nm4WdGEX3lAYyMbkIo8Ei91?=
 =?us-ascii?Q?1oP7agm1mRtuFg95/eXtwsjz8WSJ3H0FsDdPAchUVmP3ftTMD+jSBheD409e?=
 =?us-ascii?Q?H+SEd3btasddBfluKxKUSMybsMGTE3FCcCQAiibgYJ9lCpSvgOdFxdzzodlD?=
 =?us-ascii?Q?y3TPAPb6vdEpBcZyTGtwOdSN+9Q+L9sMvbWWMdhyvT2cKOO6lQzGTjz9kVXW?=
 =?us-ascii?Q?T82ZebWgZL0Py0iMDhKJXOyybrkCRehCGm3TQOt29l3cMcDyN0UUs+OwgdSO?=
 =?us-ascii?Q?MK3uX9nYZ0/NuyXddwgjQB9ZUQIXzDzviZtHP7kJJ98xwXeWrmZF8PjC1KoU?=
 =?us-ascii?Q?TSPHifT0gNigjiQiRvT7nAuayCJnlOeibVf4OJTWxs6ZKq3vLwbVHkuFFS9f?=
 =?us-ascii?Q?i30rRoihPlst8QYnvDyYFW30Gw81gz2TgexL9cxCErsDjMIrSgJXUkhI50Nf?=
 =?us-ascii?Q?qilUXrs9rCoIAAGUGTcvge0HBDbO/OU0ezFznRDkj3L+klAQMvyuFy8RE4Ag?=
 =?us-ascii?Q?tMpFq9E7f/jJYJ/i7Fb2ozxTpwapHg67pnMIAaKMKNU36iUu9WJunoLXnBI0?=
 =?us-ascii?Q?BB7Vo3nrZGuhELm+nts6ncE5JxoIWg8wsPMqJROD69UFycHxSYVLADNxYROT?=
 =?us-ascii?Q?h2FLDW0t8Gh9NjuhXi09kKWkeQGKGbpjnSgDn4JuU0kdz0bp16kKXMp85nhS?=
 =?us-ascii?Q?vTDA9Y3ZWXdaWK+sfOKoB3WXGJLwGERZfrdBAjiWhPg85XQnETVP4zGtanEZ?=
 =?us-ascii?Q?53GBRze8AtPbCljLwxX+AS+l+mzXvC7V27M0qZNBC1Le+/Pu3jKP0M3Ei0GR?=
 =?us-ascii?Q?sJidzxmbjCCOJin/fCJKBJeY0DEjnoxtsrt1mTDzziB9veUFYOo9W+Kcqp6K?=
 =?us-ascii?Q?i0FS44VwBNCW4i+QI4tmmWo4wVg4bJxSsNd98WN2wq0+VbH3DJ10yf8PM+2F?=
 =?us-ascii?Q?coqoZa44i2JCQFCJfmaGeVxCc7C1EpacV/2E9NbaExsd6+2xDT9+pfOj68Nw?=
 =?us-ascii?Q?hSRLbry0fkezUidYU55GI2fh0qy9IDnti8RVCTi/uLmRdyoDR3Gx2qXtQXeS?=
 =?us-ascii?Q?3JWhRKWT79m4wbwvf/sOtWJFzoZhQEcL7/znrvfRQXTbXmxyda8pNMeFSSjX?=
 =?us-ascii?Q?Gu8MbXwE57Lcg1JTf1Nx7n1PsX9Sxk5MhvcHZEU0/AXWmcsUaEHI22kl9Rni?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eae349f-6f63-448d-98b9-08de31f15785
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:22:55.9424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMUh+2osSdaWqIsBY6fKGsxD/3p8ZENuHk9Drft4+4hIMvARKlLEROTQWo2up5U/wVRreRG1iPBGR8wvRU/OnXMVqE1Jz7JylP4cigji17E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9085
X-OriginatorOrg: intel.com

On Tue, Dec 02, 2025 at 02:15:47PM -0800, Alison Schofield wrote:
> On Thu, Nov 20, 2025 at 05:20:17PM -0700, Dave Jiang wrote:
> > Add a unit test that verifies the extended linear cache setup paths
> > in the kernel driver. cxl_test provides a mock'd version. The test
> > verifies the sysfs attribute that indicates extended linear cache support
> > is correctly reported. It also verifies the sizing and offset of the
> > regions and decoders.
> > 
> > The expecation is that CFMWS covers the entire extended linear cache
> > region. The first part is DRAM and second part is CXL memory in a 1:1
> > setup. The start base for hardware decoders should be offsetted by the
> > DRAM size.
> 
> Thanks!
> 
> With this [ as: remove CONFIG_TRACE check ]
> 
> Applied to pending: https://github.com/pmem/ndctl/commit/39085f7
Here is the corrected commit id:
https://github.com/pmem/ndctl/commit/6834cd1



> 
> > 
> 
