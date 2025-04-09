Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE51217719
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 20:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231256; cv=fail; b=VE3wjrSpb9vNYW0GY0VAlq7RASE50FT5xeNJGt/9GNHq/EU0GB3MMHSwSluitM6EhA2/XJvMbDvFZgJzOtmsJq6kK9fuepEwAfvCS3c94Qwl0qmW6I8h5kG9CD0toinPhTML/KUYHpEbf1Pz9NqvQgL1tMu6H4IE/l+AHHexI2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231256; c=relaxed/simple;
	bh=Us2YYC2i79zOdNlzJOpmbebn1FIMRxlKveDz+P1LN/I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YylzE9wVAhaBN/RIUOfTbChaxz6EgSyPIDuzyvyN8I9yTYZU9+D2mh+QBeVY2f26/i3lE1bC3aM/H9Fidg3rLnPFIdmMI+nlIkOcLSVqujEttmgNFU5RW0ihpawYPAaPwCcxxYxZi1niNfC8Vrp9Wt95pXfX6gghuSlk5gPEQKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JXaW6yck; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JXaW6yck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744231255; x=1775767255;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Us2YYC2i79zOdNlzJOpmbebn1FIMRxlKveDz+P1LN/I=;
  b=JXaW6yckDIAG6fhs7bQuUOCpUiNm2Ul3qyAsBINpmF6SImJBqeB1fUQ8
   m75ywHlzUp+Am4EQwSbu9CzhiXfynmsF4LwjsrDxSW1y8fhF2onCJKGBl
   xyC29h7tUrozVfvxV3zguS59aJOCpeE5G6U7Fj3y7Ce7lDrD1q2IbXPE9
   5/yQm8PH5qpg88KhDGvBcCwnaQpTlH6cOpYPE8YiYxRSlz9e9YVcIlY0s
   JcUYw74wPO34Jtmaa775/swoEH0OcDRIPkIHKuqFJ7Ow6x6Gur98LqNKK
   lYAad3Fx3gbH4yQGia9gJCs6t5pbcyYKjqnFRJDebX96JO6n/lgpTh7K2
   g==;
X-CSE-ConnectionGUID: A1uSUciRQ+KrOnFTI0LlxA==
X-CSE-MsgGUID: orQhsCsRToOwox9pacDQLg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="68212129"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="68212129"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 13:40:55 -0700
X-CSE-ConnectionGUID: 8b3e1xaLQRm9uPeQtxrlPw==
X-CSE-MsgGUID: ZOqNWN5mTiu4dJErq4sYnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="151873060"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 13:40:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 13:40:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 13:40:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 13:40:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCGgTq4mmGn5L7Aw1I9nWp+2d0p5zo0IHXkKntxuk/w2cMYz+h4AVSp3RVo3lnm0r8TlmEL70cJ/GjO0lcnfDPNUkQ1W9P1GxIUwvEeVn5Gw63h7Qvtu6UgbCaHRRDxUFaO8OutqQaorJrcbCN4j3ARRlbp4KavcQ3bTseur1ZJYKjcK8l5wm7LAfYNjr/JUKb+WVgqotHpZWJLhpA1BmcsByGGYDvHc/oPYHpjQu+WX8QGq5L2tymDFKARL+qkG+vkfV67Tol1/RPDbtDDl3xLFaIgahGKF6dmxmWF938ByDb8ZvmBXPRuW6tslmnn1vpCxKjaGpr9vHCtL42q0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQm84D/T6/wmjLvfdtMXOw553BV3B5UDipe+g0cD8zE=;
 b=Nrod+hSyxLmCMnouV5JPNB40yS13dUsFQ9EAijRaflobxJGqrdNBRNcgIJruPFSpfJ/DAXDcPU/afJjfREwaij+C/GTqBYVzDoyjdKAgxV4ci9oc3/Ifv7kGVUa4zaSNvjR8FsNvJanBEXVwKeckaWLeR1/w9obqiZHdC3lFttfAyI9XLJpBM7aLgEjs6EB4dUEVJdvdo8CXnGenQjKYEwfLATlCiNxbNJf/XlXhm1He6Vrtw60tJPlkAvi9YXQFPEsBhusxJHirrnDKAOGy60WkmIyg4u1WSw+YlBlSABtKWJy5T6QuqTqfz6xrH5pwMoqpcmvJQzF/gXx/OGo4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by PH7PR11MB6836.namprd11.prod.outlook.com (2603:10b6:510:1ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.42; Wed, 9 Apr
 2025 20:40:21 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8632.021; Wed, 9 Apr 2025
 20:40:21 +0000
Date: Wed, 9 Apr 2025 13:40:11 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v4 3/3] cxl/test: Add test for cxl features device
Message-ID: <Z_bbK_XRsyYz4ezA@aschofie-mobl2.lan>
References: <20250218230116.2689627-1-dave.jiang@intel.com>
 <20250218230116.2689627-4-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250218230116.2689627-4-dave.jiang@intel.com>
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|PH7PR11MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: ab824f48-fe26-4135-2eb9-08dd77a6bf39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X2MLiPtjf8lE9XIXsGfELKXb92XnBAE2rFG44Grb4ECe3e658P0sVxe/XOTw?=
 =?us-ascii?Q?VYD8AEZz57U+1tbCaV0jgt/EqPKUMtvK89OaRAfriTpAk7BVrc7tQ9rgxZ89?=
 =?us-ascii?Q?hB5m2E4KfdpW3MhVQmZdwZSQm70l/AxtYI87mHblH8/DeBi+lMkz3St/RTp4?=
 =?us-ascii?Q?VnEyWpwlWsSaUyMHhk0CxIEawkyz/9hR82hOGexX6XNTeQaHjYb8kDODcMm6?=
 =?us-ascii?Q?qGIywH9XF33RY1N6CJI56FOYqstCFncPhTSiMuwYlVU1ZPLkDvuoB+GzwuTW?=
 =?us-ascii?Q?iWLcfCFaBOeVKT2xQ2X1hOHM6ReUPQo5HW9718E8Y28WYyvregsNqbZJGz4/?=
 =?us-ascii?Q?PBH9L+HYgiLjXFO8kk8W5J3B2yc/fZZw00bFmV75rxgBmiyhFPke7Q6uXuiD?=
 =?us-ascii?Q?q3yDetUUz7EHekt9k5LrI6ywiwXSdZra/qW/G55WlfcBWUZp3Bjb6jCPCCm7?=
 =?us-ascii?Q?74QL2gfIeRT0fliq/4PDpZSVHs0HiGCXlF8fUEuiHm2sMzx05Iw7DpzL9cqu?=
 =?us-ascii?Q?C2kzQ+zSMOcO0cqPOcbu91xupWzGEw8Q+zFYPCAG/W6ls42Dcc2lLgD+2sNI?=
 =?us-ascii?Q?tTIWia2i1WIGHmkJXUj0NeC9jgoWfw/N8hoI/YQlrSloTy9WihVx/4bcaYE5?=
 =?us-ascii?Q?rw2Dav0QrNq+90lADsr+R/QbINNyUAQR48qyg2qjQ92Hyah1NpqXDKk5vEUO?=
 =?us-ascii?Q?QLfSxbBNQmMY6sE/ZUb7jfNgXAp5pncihPjkzTm+Sr6JUVRKtyErqa4HpVuy?=
 =?us-ascii?Q?slLEJZGjySkfg9FDRlZD4FAvFVtlR0ubA6FgkN8z4HCMJEZjfbwFx2awP5LR?=
 =?us-ascii?Q?VAFASfHe2a8b8NBEto3zQeYhQegiyerm3dkJi55yekqg0gmS2jRXDk1A6lAa?=
 =?us-ascii?Q?AGMqigssXdXFv4B32u3dCL9T4VCiDavnDd6dEWglr3Bne3hwKlFn1s74lJe6?=
 =?us-ascii?Q?l7Z/U5SZoSd2NBupnpfzwA8CAy6vTxJW6eYhvnnd1Fji2hsheorbCVYUvDZp?=
 =?us-ascii?Q?3Hg2iQE8z3F6CDwqGEnpYaXNaW/odrC9q2kDDVaS3eba+mgjWWoJ7Cb+i5xX?=
 =?us-ascii?Q?pMuUk6TN+QyXUl4jMtbgvX68KKdx89fSH3C/Jozp2H5EVkv8lU3zjlIOgOKE?=
 =?us-ascii?Q?O0l0Kog1kf70+gOXPQUvjlnOzekz0T+FJJ995Tha6Da8yyiJRVPzsYrfif9g?=
 =?us-ascii?Q?YcUJYLmOS5DSCODBki+53g9hsyQnUVhu/Ft9FUJMZIylOXe8vWpbiDM/rTyP?=
 =?us-ascii?Q?0akUVi/DIbDGKP0LA2HeZTWOpz/7M6+EZndCpX/pi1cqZbuv9mp3/jU4XjPa?=
 =?us-ascii?Q?e606YE2PcHAE7auZ/c3z8OjfsZKktLO+oIxkyUN91NfqL8EPJyK5PbRQJ98t?=
 =?us-ascii?Q?QSXtPITVxEZxp4QgiQgTBhFaiqLf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dI1XrW6MmfTSYPfLYa1rF2M5eVFxhtxIkczmXL4Uck7yLtU7GDH0FxGHp4Y+?=
 =?us-ascii?Q?aji0FgQxsPgzice8P+hzsZXiuFr/njRAzKxVdv5B7nbIYKiv7pkg9QQYx2P5?=
 =?us-ascii?Q?yRQeGxC+V4W++9Fwf0wmZjz+U5SdcD8d8w+/rKBmXZ9ZbZNSazaB3YDd+5LD?=
 =?us-ascii?Q?aoSaOMLKHTinFWpaRVa0ZmyoX9sQKXtzjnfDCUctlvHKY5Nqo34p+9gCpcor?=
 =?us-ascii?Q?OvNgGz9VyNEy7jE47ZuicfkjbtAqmg2rUnQZcBD70qdLRFlArXAhuT6ZFQV5?=
 =?us-ascii?Q?UlFG+ZUm7tH+Ln7IpkLibidewnWHK98a/VPzVuCzk7nvSa972ZiroDxNNkhf?=
 =?us-ascii?Q?h3fFKRdUzvWIFRiEGg2/vcJ0Dtjk7EhhHiOM0gjk/ZjkffA5/XTh0ZAJfo5z?=
 =?us-ascii?Q?d/eOIbekiOXsCbyl7pgJ63dcV9MTk6pJ3indo1S/jZGDe/nVcuw/Fk3KiCUU?=
 =?us-ascii?Q?109ri+ZkDvXiY+6YKV/W+hjPqCqMyRuJEG7hqUNP8L8er6qJJYJ+IMONq1p7?=
 =?us-ascii?Q?Spn/3//3v4NfrAjusEWMAXTcTuy5u9RoktrFZHGCyLeMoBL+U0/68yrCoegU?=
 =?us-ascii?Q?5ctQhE4ColxeOpKmkPcuV1M1nErMSkJznYaFwuFDI9sc9Nv22pP3BHuPBh7I?=
 =?us-ascii?Q?QNXOJvCy5QiFg/BulV9oKV9klapxEeMnUX4uD6+8BCMfB54fCeLPAirkWaGE?=
 =?us-ascii?Q?JdARISone1I3OHkt7whwwOOtr6lzSQ8+RHNXhlIPs2Vxg/RfNgzVhcDvoR5x?=
 =?us-ascii?Q?uxzE51GMBteIcz1yq40x9CdBFk8WGq4ObqoD5Eh5ns2UM/ABSOg5Rmc+R5SC?=
 =?us-ascii?Q?PBcgvOMZz0dBaa8or+g4vO6ipHzt8N3er8hCcb4CYKsvmV3357PJfXD/JFiZ?=
 =?us-ascii?Q?b43WD/DafXbpPjNk6q0Vo8FO3MfpjUbkQOy/NkYSvSJTT9NDH6eRph5C3yM2?=
 =?us-ascii?Q?DRQYMlJbR0C9Rs+MOEWj+RK3vabMbbXdxAeAkA6zR1+KsORyg6vWt6YG843O?=
 =?us-ascii?Q?EJ832DDVsAQD6ltiQ9jTe5lmtg44jzojxleHfudTgWVJ7FxIxsuJ//zGQvNB?=
 =?us-ascii?Q?vH712yXUQSYEuZ4XvWaheBXBBscSiaKAc1bYV5uh1CQK2CiIZgzIp+c1evxf?=
 =?us-ascii?Q?vxgvZCKseGi+uLz3FfEXa1uBIpFqIjplYbFhaAhs7ma+tsBq9LKxPa5yajug?=
 =?us-ascii?Q?mjeFrCYgDLdK6exiVIIqsPpYjsVPBI2LAmVHKxdNsfcxXFk8ChVQ/CVJ6p3Z?=
 =?us-ascii?Q?AOmyqTviv7vW+55+qWJx90tcap163C210+g16ddSC15Y/NQuXXI038nLSxds?=
 =?us-ascii?Q?tcZes09k7l5VR6xUf+fy5acTFEk2DvXKDLPJki4JnXQSapUnfhAGNZuXQpxG?=
 =?us-ascii?Q?RKQ+MxceKrp7TcKgMDWwZu0hiQXs2hSmd0eSYF+7Kdlqje0GCHgZVl9RTwtr?=
 =?us-ascii?Q?A/TjFOOwBD0CEHlplgaLZxK8KQvNEozRmH49rH0sBSM1PV45syq9150rrWwZ?=
 =?us-ascii?Q?Qo3veNEZxHAtXvsahp/QuDF7f87WPq05tDQDjEQh6m0sS8oPzFgjvVevSyyU?=
 =?us-ascii?Q?kUHzOreSJFCALXrKLqakUDLjTj1FUrmAq+VJEKSpv4+6xsn7kkbQWhslqBIA?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab824f48-fe26-4135-2eb9-08dd77a6bf39
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 20:40:21.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMB5VB8LgvR1uBYAiEAdpBbmr6ZY49t6WS5YosWPd+GoZ6eYOa63FdPtUUaHGsns4aVgc1GL4G0dpgPR0Nj5N86iaMOKH6ry9S3CdrGuM6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6836
X-OriginatorOrg: intel.com

On Tue, Feb 18, 2025 at 03:59:56PM -0700, Dave Jiang wrote:
> Add a unit test to verify the features ioctl commands. Test support added
> for locating a features device, retrieve and verify the supported features
> commands, retrieve specific feature command data, retrieve test feature
> data, and write and verify test feature data.
> 

Let's revisit the naming -

If the script is cxl-feature.sh then would the C program make sense as
feature-control.c or ???

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v4:
> - Adjust for kernel changes of input/out data structures
> - Setup test script to error out if not -ENODEV
> - Remove kernel 6.15 check
> ---
>  test/cxl-features.sh |  31 ++++
>  test/fwctl.c         | 383 +++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build     |  45 +++++
>  3 files changed, 459 insertions(+)
>  create mode 100755 test/cxl-features.sh
>  create mode 100644 test/fwctl.c
> 
> diff --git a/test/cxl-features.sh b/test/cxl-features.sh

snip

> diff --git a/test/fwctl.c b/test/fwctl.c
> new file mode 100644
> index 000000000000..ca39e30f6dca
> --- /dev/null
> +++ b/test/fwctl.c
> @@ -0,0 +1,383 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2024-2025 Intel Corporation. All rights reserved.
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <endian.h>
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <syslog.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <cxl/libcxl.h>
> +#include <cxl/features.h>
> +#include <fwctl/fwctl.h>
> +#include <fwctl/cxl.h>
> +#include <linux/uuid.h>
> +#include <uuid/uuid.h>
> +#include <util/bitmap.h>

Not clear bitmap.h is needed?

> +
> +static const char provider[] = "cxl_test";
> +
> +UUID_DEFINE(test_uuid,
> +	    0xff, 0xff, 0xff, 0xff,
> +	    0xff, 0xff,
> +	    0xff, 0xff,
> +	    0xff, 0xff,
> +	    0xff, 0xff, 0xff, 0xff, 0xff, 0xff
> +);
> +
> +#define CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES	0x0500
> +#define CXL_MBOX_OPCODE_GET_FEATURE		0x0501
> +#define CXL_MBOX_OPCODE_SET_FEATURE		0x0502
> +
> +#define GET_FEAT_SIZE	4
> +#define SET_FEAT_SIZE	4
> +#define EFFECTS_MASK	(BIT(0) | BIT(9))
> +
> +#define MAX_TEST_FEATURES	1
> +#define DEFAULT_TEST_DATA	0xdeadbeef
> +#define DEFAULT_TEST_DATA2	0xabcdabcd
> +
> +struct test_feature {
> +	uuid_t uuid;
> +	size_t get_size;
> +	size_t set_size;
> +};
> +
> +static int send_command(int fd, struct fwctl_rpc *rpc, struct fwctl_rpc_cxl_out *out)
> +{
> +	if (ioctl(fd, FWCTL_RPC, rpc) == -1) {
> +		fprintf(stderr, "RPC ioctl error: %s\n", strerror(errno));
> +		return -errno;
> +	}
> +
> +	if (out->retval) {
> +		fprintf(stderr, "operation returned failure: %d\n", out->retval);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}

Above the send_command() is factored out and reused. How about doing similar with
the ioctl setup - ie a setup_and_send_command() that setups up the ioctl and calls
send_command(). That removes redundancy in *get_feature, *set_feature, *get_supported.


> +
> +static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
> +					  const uint32_t expected_data)
> +{
> +	struct cxl_mbox_get_feat_in *feat_in;
> +	struct fwctl_rpc_cxl_out *out;
> +	struct fwctl_rpc rpc = {0};
> +	struct fwctl_rpc_cxl *in;
> +	size_t out_size, in_size;
> +	uint32_t val;
> +	void *data;
> +	int rc;
> +
> +	in_size = sizeof(*in) + sizeof(*feat_in);
> +	rc = posix_memalign((void **)&in, 16, in_size);
> +	if (rc)
> +		return -ENOMEM;
> +	memset(in, 0, in_size);

How about de-duplicating the repeated posix_memalign() + memset() pattern into
one helper func like alloc_aligned_memory() - including the memset on success.


> +	feat_in = &in->get_feat_in;
> +
> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
> +	feat_in->count = feat_ctx->get_size;
> +
> +	out_size = sizeof(*out) + feat_ctx->get_size;
> +	rc = posix_memalign((void **)&out, 16, out_size);
> +	if (rc)
> +		goto free_in;
> +	memset(out, 0, out_size);
> +
> +	in->opcode = CXL_MBOX_OPCODE_GET_FEATURE;
> +	in->op_size = sizeof(*feat_in);
> +
> +	rpc.size = sizeof(rpc);
> +	rpc.scope = FWCTL_RPC_CONFIGURATION;
> +	rpc.in_len = in_size;
> +	rpc.out_len = out_size;
> +	rpc.in = (uint64_t)(uint64_t *)in;
> +	rpc.out = (uint64_t)(uint64_t *)out;
> +
> +	rc = send_command(fd, &rpc, out);
> +	if (rc)
> +		goto free_all;
> +
> +	data = out->payload;
> +	val = le32toh(*(__le32 *)data);
> +	if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
> +		rc = -ENXIO;
> +		goto free_all;
> +	}
> +
> +free_all:
> +	free(out);
> +free_in:
> +	free(in);
> +	return rc;
> +}
> +
snip

> +static int test_fwctl_features(struct cxl_memdev *memdev)
> +{
> +	struct test_feature feat_ctx;
> +	unsigned int major, minor;
> +	int fd, rc;
> +	char path[256];
> +
> +	major = cxl_memdev_get_fwctl_major(memdev);
> +	minor = cxl_memdev_get_fwctl_minor(memdev);
> +
> +	if (!major && !minor)
> +		return -ENODEV;
> +
> +	sprintf(path, "/dev/char/%d:%d", major, minor);
> +
> +	fd = open(path, O_RDONLY, 0644);
> +	if (!fd) {
> +		fprintf(stderr, "Failed to open: %d\n", -errno);
> +		return -errno;
> +	}

Needs to be "if (fd < 0)"  as open() returns -1 on failure.

snip 
