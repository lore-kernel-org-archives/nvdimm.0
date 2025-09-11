Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B6535A2B2
	for <nvdimm@lists.linux.dev>; Thu, 11 Sep 2025 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609427; cv=fail; b=lVqARgZ8z75pO9FEHszYej7tvk0yyRK5fuAVdeuJjWpO/CZJWGp9S9NDrBi3eQxNANupz2Htq0D0+kiYSSTx2fKtCwvxSGiX7AWN4AZpRbpqs1JVyZw3XH+uo0n+wePwb81YmsQUxKfwqYnHRezvNzxuXmludt5MshLDCIpcD7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609427; c=relaxed/simple;
	bh=LxqGJmX8bKL3B0ksjFTN6VUQ7xgpslwYbmk4/UQaOAY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LySmLH0nCqgTO6s/+8ZJeH2NajviHjKx4rg6DikyIx+5n8R9CIG5JLURPIudeNaFNaNpLM7W+7X500h1rStTAlDsr5rCBGkOjigsNFmN9IXEXbiMUAj4o65RrqSQ5hm4xTYIt3Kixr2BOKMUZn13IUILPuqJmKPESbIVIwv1Cgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JtGHKLZB; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JtGHKLZB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757609426; x=1789145426;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LxqGJmX8bKL3B0ksjFTN6VUQ7xgpslwYbmk4/UQaOAY=;
  b=JtGHKLZBm52uSRBVaaJ1Gw4HuMJ5LkY7rmEzcktgiJFjLRAKWtzHzINs
   CDAOEWe35UTO2uChvue8YC9SnigN5jPrbNaoJ34+2eLe8IZhgePA0CIJT
   jltyT0DSWKxlcgjwEmYXym5T1V6Ffm8DgYQ+CuJYgNOmaMXiGaSxY2w6q
   et7PAARiIR+zBh0g6m5j6DKeVKMlbPD5HaTdbJGaD/n1gRQReH1dbZoW9
   ak/mF0iVurBNfPYVdZoHmQ0qm9L2vpVhfQyZGDYHb9VLXP2+twcZeKlwD
   tgwmc96B7vxIPPh23a1U1rOS8gh3gNVlA7S2Kv7qMvMQzasNoQw6meVIK
   w==;
X-CSE-ConnectionGUID: WSUcKqZGRGWgNG5ej1QgEg==
X-CSE-MsgGUID: P/HjA8RDShiVFu7mMKvFag==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="71373010"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="71373010"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 09:50:24 -0700
X-CSE-ConnectionGUID: kz30b24xQreFHGn2ZWgQCA==
X-CSE-MsgGUID: APTpiyjnTd2ZaANRYoezkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="173642616"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 09:50:20 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 09:50:20 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 09:50:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.52)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 09:50:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gsoiO9TKblBwU7I6VauP/xNgd3LsttWWm96C1MU9q7Ni70M/zHImPWSNfO/XKBdVugJ/yan+rBGV5Xs5Z7AzO/U5swseiWeX3M9WXkPdYtDFiVwv5FHKcpCY3YYIyANiBzq8yHu7E0bR5XRput+DEC0+LrqZPRuPKmAAqzhEJu8hDtI/6tAPEFnq5aHqGGVNb7XSmaTPi1rloZkBQTpQABTstllz4j/tvKgLhHSSPTRl7ETck15c7p9gLsAxfh9XwmsfuUrW3VLiA4IOvtR61hV18ZM0EYMIyni/3QtFeW+NnN4burxI1ab7uEXCHquiQAcEkCgVQoOlK4GNJ+0rDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxqGJmX8bKL3B0ksjFTN6VUQ7xgpslwYbmk4/UQaOAY=;
 b=cjmmdq6qadXnt8kbvsPtt79J53NOXVjE8+6m81oGCAzRSDHZZIF/Q9+RYa64bVb4rafaAL4gnKyr3nO6nn+i8MIuSYSq01XW5l7mKdUt5Lz67gzvI6oMVu+TPQ42bRmtdu+r40NFFZAGBHQRlFTDF/VwM45Mor6sSa4uM7BXLEHGt3nfSmic7ByUHGC1xK5apcsNtlHQj2Uzt4S+zV6O/POUmG8x8sTXZHc2t8L4JxNocma4j1KqEgYsOgWBJ1B+ptnCnN0aqcrb7EnF+zXQy2osA13pamGkuU7Kio75NU1vTaRxbN/htEr+UjIpYMAB1PonqLv4U+7SgG+b13CuHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4890.namprd11.prod.outlook.com (2603:10b6:806:117::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:50:16 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:50:16 +0000
Date: Thu, 11 Sep 2025 09:50:13 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Yi Zhang <yi.zhang@redhat.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
Subject: Re: [ndctl PATCH] test/dm.sh: fix incorrect script name in cleanup
 error message
Message-ID: <aML9xThlMe1_JX2A@aschofie-mobl2.lan>
References: <20250911002906.806359-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250911002906.806359-1-yi.zhang@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0123.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4890:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ede19e2-1c99-4a9c-d1c1-08ddf1534900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?c+2HYtNmWD/iXr84e4Gfsn3NEQajbVgKgMXEZXnCkZmzPmsWh4XfYQ2IMXZH?=
 =?us-ascii?Q?CN5cSIzSaFEf4pjathYIIk2fxfLM8tFXjp6H3iZMUh4CwBKXDhEDVJ+5xHS3?=
 =?us-ascii?Q?bdXhVyLtIZ91I7Iryr0gjYcwXfacosO958VWtkitIIbY+Pka1MB8U0XvKPhx?=
 =?us-ascii?Q?f8x/MJpazQwa+1+IfrpCvkHdU/T7wxJHGJ/0OYoNwJj9xdB5ZCFLkKy8UY4i?=
 =?us-ascii?Q?pjDAmfMEibLQFXGFehOxh0XDz2+X8JR3vdj6dtXye+b19A3vq3dbqWqjiQia?=
 =?us-ascii?Q?3vb2HIFPty2FaUWazyPcbwEyH/QGq6ma48JylngeUKV6+CKEEGb5CS0DtdDh?=
 =?us-ascii?Q?hy4j+h7JY+X05VATJfyur6Zp4AufSGkfpdnt9pWgkar0m3tSDZe7Me1/utOn?=
 =?us-ascii?Q?WY5PiaN02Rngfh1K7uNOXwi7azvY8KsW7z/PEYSg6zXeC7wzob+IwQOzfiAr?=
 =?us-ascii?Q?e4ficpuFaIkiVsCdKBW70wcE3PDPniGvMccBupQZ16l/C4bI6MKlsdrYnf0i?=
 =?us-ascii?Q?xaUoGJxF1J6+LeqJKiUWcTBCKCGijtn4i5DnJCRm/W8zG/cNrhvtXnZutdaE?=
 =?us-ascii?Q?/Iqb+AWenXdsyKmu/WBacWAQ3P4LwGhI5L+CaeT7GLm8w4O+KsewwYTd4BUE?=
 =?us-ascii?Q?ioy7IBM/D1mYfqQycrRYyDlK2qnQFyTXkberQhq8AKpwAymThGBc6h6QOO14?=
 =?us-ascii?Q?sJ8be4fXPJaPDZ5Y+M9lQJVn319qONpVUE2VJIOfOu3WpCpMinV9dyPhqqLw?=
 =?us-ascii?Q?cHvLPbBIDR8Wdi5+f6zKWAFxiFB7+1PkstCd5AZTTaM1TP4RorM6ORD12spd?=
 =?us-ascii?Q?QQbzZk3XQM4g7jEEe5k3556Qqld3Dhgrx7jMRTIRq5bh+0JHmYums1dbLm82?=
 =?us-ascii?Q?HT8WPk0DnlvxjP4/zrjAGWiGKwYKJOiflOQqUHiLlJ+HWgMSdRtzI9ys3xnS?=
 =?us-ascii?Q?ZtXNjG0rTKFt2Y2bcaQdG0dutkUo1gl/MYh3fTVJMhPp5COLeukrvAFLHwXK?=
 =?us-ascii?Q?5xS2osU5wY4mlj4D+XmAGFkQw+GpAd2z3nhUKVZTKXA8VoYGqnryIaCtaJIH?=
 =?us-ascii?Q?375GWLA80VEzqtgyUPhphs2b+knthM26WSjvYw2cUb5hyzW2fKYlDm2JdSi0?=
 =?us-ascii?Q?gBqxbWn7X1XtHE4a5Tu8NucUXnCscM7S5Dk82A/DUwBrZncIiJIGF5Y/evA3?=
 =?us-ascii?Q?QSWpvxMxPQ4Qch4ihyY4PShWHnuqQDPp++i6HFvKF2EGlhhuhnnzUprXYSbz?=
 =?us-ascii?Q?E+bd7Zq1iy2vl5CRyoK/5GHKIzGxQOyNRTw9UILf/WA5MW6oKSir5VIqeN7n?=
 =?us-ascii?Q?U119TRi5r6/GrSppXPQ5U1jxaiNsGD6OfmoRbGYgaRCKt1PrxITMn89UO+L8?=
 =?us-ascii?Q?dyjx0//WM0Xm3B8SyYCmF+/f4obtmKW8q6flf3UMN6Nq2CIRYrMcYYqVfoFO?=
 =?us-ascii?Q?uWw6VWvDRFA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u6cb8n/764jtGA9+CMR9z7nzPloSjJ9MbEXLyq9mwwRtGLVo5i8u6GrX5XFA?=
 =?us-ascii?Q?1fb7qH1JMsqqor5bsPNrtmtfCXGeCtuaCEQ62QvSug3g6Y663bbAAsarnUUX?=
 =?us-ascii?Q?G6b/PaMzQ6VdlKzq/kq6RIgZUl75bQ3BBpsQYFis6I3bSvInLxsEIn/2b7v5?=
 =?us-ascii?Q?/+OZPypIQ2UPegvUMltqh7NeB9yaaYw5Rao0aWaKyqu0JYKYCjjvcHNf0ic1?=
 =?us-ascii?Q?tqEnWWhjdFS7VRMz+BPTuYxMHiYpCTdmwZ2NFVBfFy9U7MrWhoGxTMYLKfSy?=
 =?us-ascii?Q?pTULqy9ruW+rJzjc6S1BsbziBrZJqebusJptGHbQRCSzEEVZSEtKwCZGHZ74?=
 =?us-ascii?Q?/GNm70eCQ0+hWiSrsQZIIfN+SlWcPQAbf+QztEBhAFREsQ8ZpE84cUbjMISj?=
 =?us-ascii?Q?Ob2RH2UsL025rhpGR5W1mZCZYq7+FgIzgFqFeIOqOwbg/G/TaRsiVPhoh4N1?=
 =?us-ascii?Q?TdCw+2Sq+l3+o2zT+Z5rLkWluFeAh7A56/3lt9Be+piSWEzCM0GRwnuwqfed?=
 =?us-ascii?Q?a/75DxqF8B1RwkSKwZ1G4BhUSFgZNBZeuIINpYy1XDOlWoEc47rYhe9plNoF?=
 =?us-ascii?Q?s+jSK49yVwAehWB4VTMkvptyDIfTX6oVBk8M4WzUBkKm7gAbGwD86oYU/XMH?=
 =?us-ascii?Q?dqvNM9no2a61Ef7xF/dBAa9TusSAHBwPh5mvjGPPa9RNVw7xzR3vYYZCSLJl?=
 =?us-ascii?Q?poPLu2u/3eePFdR4ansM5Ln2vFKZWvJ7vl3bYvf+1vlTihqV5NUfSLNR/MEt?=
 =?us-ascii?Q?+OCkm6POpxJfSXzKAK51tZnTLWUz4xf810PJEo5JmSX1/q6f/GD6KNOjJeOG?=
 =?us-ascii?Q?5zLNn+BW0ZNGBboQLkHTzifVMAhIa92EeA37vjsmgTEabHcq50VZU+ggZmG7?=
 =?us-ascii?Q?eXjd1C2WH+g7CUBxAIJcb2tFmsCVBc5C5gld3253JMoFBDr+/VzOybjY4Yt3?=
 =?us-ascii?Q?HYnQg3ToI0gFXWn72M14TV9AIW+kRlP8vI/J/HA70jf7Vl3PJVe4fiv8ut9A?=
 =?us-ascii?Q?sp7v3PbmpRuvgas5/h4lVpKI3cdZdChooYtRaSlyO9LJFql77oL6rLArJJhp?=
 =?us-ascii?Q?aEG+WT0Al41SsRpYy0MdZpkSLRS+5nkn8dT1unSqEokdE9aU7yQSqdCTHtim?=
 =?us-ascii?Q?/Sf1aDFuJncmjbe+fj4nrJ1lUPzNarA5t407BeYybeT9fUMfor03IQCCLFW5?=
 =?us-ascii?Q?WdpeuWddoxYNXO8A/1lF3Rg8fBL6xNXrnGL1RIdPO7s3hMu7prUFcrFCSbLW?=
 =?us-ascii?Q?PWe2nZrY79pZ9CI2ZjsHCQjkLCv0N6OEEKytvEEJQxGGgxjc7NLV6pbxdLwl?=
 =?us-ascii?Q?zN3jYvaDSRQk5tg0N6WdhtYjcBDpdcSnw0TZx31CWS2tj1VmmYN7gq/hGZF9?=
 =?us-ascii?Q?SctQcwkpClKzAVtXnPVhzfrDgjyW1N7dagBfdveK30LauA/38EnueI5fE4IJ?=
 =?us-ascii?Q?mHhesrKMrVdrjH8wxMBGFs08vQcrl9G8/+zoc7xHjLVU4+VyzxBk8iPWNBez?=
 =?us-ascii?Q?kV56LUQOy1PAzO00apberB3/7eHX3NsS5f3vnyYh1addrNAU4sHwjxglsMt8?=
 =?us-ascii?Q?lNyLhw71C1/gYwoUViaiNErjJIWSSRRtOaLdMv9qFBV19ROBwctPr+Tv6hiW?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ede19e2-1c99-4a9c-d1c1-08ddf1534900
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:50:16.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7a2Z8j8cZGjJF+8oLT0Mg1AjvIGYLr6RKxtT+fpxx+7eT3gFK2z5ZzCSv25rHqaP86JsEsAzyv9vV1TiWkAl9i19bo4kyfqxydAKG05HGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4890
X-OriginatorOrg: intel.com

On Wed, Sep 10, 2025 at 08:29:06PM -0400, Yi Zhang wrote:
> The cleanup() function was incorrectly referencing "test/sub-section.sh"
> instead of "test/dm.sh" in its error message.

Thanks!
Applied https://github.com/pmem/ndctl/commits/pending/

