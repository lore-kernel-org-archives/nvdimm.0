Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A049478
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747183878; cv=fail; b=lktrqsQf0ZhBrmiBLScfq+32y24unQTNHke8Mw0uxP/oCGPQviiVysrQ7bcULby1ZpVkaLncoOhvE0+Lgg29g/CgkTlpkk88wHjFQoIjMf/Gz5iHdhs/tYEgCsFEi6Pfmv8bCs8m92kamz2PjeFzZvm9t2jwtLmClTYVZze2n9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747183878; c=relaxed/simple;
	bh=x5FgCWcipdQL4dSvBKf00Jp8pc+ivrumiUQvP552Su4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rjpv4VsEAhz1uIkzX+OvhSnVc0p893iq1tG+cM2bbySVbgebaOx9E+0w7JdTnB8qQ+oFzqyPdWbVRIxjD6lQC8KeS8yqvWjhkrlzBp/BgiVcHHSw2ni2kcFwxuCor1DNVFI1qeefPJLDBkVIsUAGOJKWQGZHugsQV/UKH0wvQ1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N1LWwPhQ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N1LWwPhQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747183877; x=1778719877;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=x5FgCWcipdQL4dSvBKf00Jp8pc+ivrumiUQvP552Su4=;
  b=N1LWwPhQKGt5xzsqn8iP8nUF+ltm04SVRtVOgVCCFkK/wpAx3qfXWXKv
   FQHwOcB7jTwm242jnQJaWnOYsRyPpy9hfJEfhuqpxKqvbIPBdZDmJ7S1t
   7QpIB29vEllXzvPm+FlhCqk6yooYKBLaY7zYZ23NNxOKkvCz8EqRp5fyE
   bLxuVtefb9Um1c+HZzqamI+1DV0tVWtjr5bsTh1/Ps7vWUtjuJVOlIXD6
   H86pb6xIayoIASA/NqNyvZcvP7mugxgBsA2/2EGK5aChYfX0gXQrPlYzH
   qpaBKse9+zInkd/Oj6zMmUSmJDWlpK5skpH0OCWt1+d1JKtwvrZBdhTOm
   A==;
X-CSE-ConnectionGUID: snLtwfhGREaHoW1K4EWI2A==
X-CSE-MsgGUID: FXGNYgKBQ8GCqCMN122qdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="66608625"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="66608625"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:51:17 -0700
X-CSE-ConnectionGUID: flnjMxNiQfidlRt2y2/e1g==
X-CSE-MsgGUID: /se1/iKSRJ6LbABaFU9Jbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138796645"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:51:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 17:51:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 17:51:16 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 17:51:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJYmZloRD7A4AbkAkWATeDjqQxr2BsiWvrm5XHb5F75DDteDOMtNdN8SGnHK8+C/pDlGoh12vEE0EeORy1GCjulf18NENtyCAuQxwB8iGL782trwsJEmSfxpVs7ekgR91kuFkj4mIjWCL3JK/ZGM4s5f7EVJ93VgcBIRlMbWsPDIReEoSReQ1+u3/nufFC/uLRaWW7oBV687KRN/F+0V+m34OFB7DZKf0uR4IlJw9vQ4P4AJH0zfFxhcGomoWx9gpKyjemauY0rjyr+yddEhYm0lmEyHe7zJeWWLfAZY7qVvNYSRAgvwHizh8TJCKiEuQuxe//YREdOideAIrGQfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bruwd2fqcUGbWnlP08ZtR50ov14pBGzkBnnN2CPDQ9o=;
 b=e3+nhK7Py4Tcg5ADgyg8kWybNzzaVQ6ZfLleo2ZWo7Oktvit5Kthl+HaWF9qXMkJ3JCD56E4Agx1FCA1xcVYksufyy1Mqg90VqKf8+/97fSjQGHco/Vy4dyr4uX9kkmoB1bXLspeQo0geONkUZfUZV15JRqXAkeaNgGDV5RrLDivC55+lPCv0FSox/0o8rNb6kFOUl7zU1dMkA3AFNgnYXBTgt4NOTAi53ZwTvLm44SUIt1F6wdIUCQGJcrbYlHj66YSi/Ietez8SKKK4/vK0s/hphgcnSKBxcyRd4w5OU2RZ9eE7v4+z5ksN+cv5qmBEFxT7TM9/8HNXyGz5ZFZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS7PR11MB5992.namprd11.prod.outlook.com (2603:10b6:8:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 00:51:13 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 00:51:13 +0000
Date: Tue, 13 May 2025 17:51:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v2] test: set the $CXL environment variable in
 meson.build
Message-ID: <aCPo_u0wOljHCigP@aschofie-mobl2.lan>
References: <20250508183142.743047-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250508183142.743047-1-marc.herbert@linux.intel.com>
X-ClientProxiedBy: BYAPR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:a03:54::29) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS7PR11MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: 08174b88-ecfc-453a-3b84-08dd92816d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OFXNfO51ykUFS2cMewjH8918qjyGcYV6963sQYJY6a/l98XQ8VSzDqzRujeS?=
 =?us-ascii?Q?mHARkdcFjnVJm37odzeZrfwDD75Dxv9Fl54YgNAqf2KG7SaubQf4e115MeMN?=
 =?us-ascii?Q?WEk/uG1LrTTiOfMPZWAAphWsVhOfj0d4R5SoMxiVMW+O4Ez2PPeah2oDeYFU?=
 =?us-ascii?Q?HwahoJebMeEsNZUPWY6syaRNsIGc/GlppPwAbtYo9kOYePllYybzUskGohj0?=
 =?us-ascii?Q?HS0TpuNSG9FfdsiJVYnINdJy+DzUO4VMPggl+0DGJm4VgVweK8f0wlKezx+m?=
 =?us-ascii?Q?Uss99vrCgOBRnk/Ed851VqeRg/OlDdGXYWBTQcni2KVgzhJFS4wINrr5AFuU?=
 =?us-ascii?Q?5x5zzWUekePxT+ZJSbVp3F0lhzZ/oPyLFp7Isd+mUojxdfkuXeDyLt9RA6BZ?=
 =?us-ascii?Q?UJOGAdQ/lJAapQsNXft8JA5zV8DGi4UcE4X+AWRdZWLcClwuel5rqUnewD5s?=
 =?us-ascii?Q?9wlpscdvVEiceDCRZnbiCDUlwiZw+eUIu+8igR+VB+3rO2wo96/t0omO+gtb?=
 =?us-ascii?Q?GWYAyK75oGeW2KICFrD419MJWJgPJmFNxIq5EsWzCJ8WNJ+EUZkdVig+iKf4?=
 =?us-ascii?Q?ixjypngIa5uHYGcw7Os6fteafNSWyIEmeHZX/U0M6v/ZMP+J1EOAef33AoUZ?=
 =?us-ascii?Q?/vtLgu4e7nBcz5YJp/JCGCwkwgR7dWegZEYqbLostl3WtEuvfeXhwyiXhZdO?=
 =?us-ascii?Q?vI0LLAA8G5fTW6qpoU97TFSo+oM8LrGYH6plSiPMK2jRr3kmx1QEsnIBkg0n?=
 =?us-ascii?Q?7LwuFtNNFN9bsf7F+zQrtMs5oJf+QdkiS8uGZ7GtTE80w1aieW1l4ChckivG?=
 =?us-ascii?Q?tVVWz+KJIGBxI9xjW7mKtgiCiOjt7/duHmW6C7uMkmbt3MX2/shvgRxTvz1L?=
 =?us-ascii?Q?laaIDtVXDsw7OZIu8t6bLV7Ex9hgQU883f+HMySpVMk2b0VOPs7cy2J3QsQN?=
 =?us-ascii?Q?Fsi1baPP4j8aq0lAtWJHDfCZQ9KGO6aVxd7GBghchmQQgmRGMiWhMCD3284g?=
 =?us-ascii?Q?ucdeHTGEIAkIuC6TG6jvibXCCxtwsvoCbKs4O6tW2yZqfOynO95KhNNRX649?=
 =?us-ascii?Q?T5NY9+jY//L1YMPRSbS05fZvjMvLRSRYOe3F8PgWm0Xgs45JnpqjffOp/4k8?=
 =?us-ascii?Q?Y15WxWArTNZE3t42NqZWvllDhP5rOodzaxRsrZEgYBOfi6IADKC4IU1OOA4I?=
 =?us-ascii?Q?CX5GIZwvw9ltduAiu/XQxjsaHGyHmGU3/KmbKFv5ZGF5GiSh3fFwhyryy+BU?=
 =?us-ascii?Q?h69UyzVbPl0sLBVQsEyg91BAzmiH/yD6NFbm/pmNi1sXNn53neg6yKZ9tOlA?=
 =?us-ascii?Q?OU20fHyVVKIkY6seNJZufk3/y+h51AMcQqLMT8NtBK0CXwhmOm3OPmuoMHuk?=
 =?us-ascii?Q?kwrviIm4AdqYA8YTiKyYe/73KUmML+z1gn4LcKOM0S+GehvdSzvleQk+mxom?=
 =?us-ascii?Q?DBoxdRh+zlc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7DFKVkx+d+qgpvbmgGttevNOCrRFTP+xIwzAMxNWfYIBWqk9sOkVmd+DAhgo?=
 =?us-ascii?Q?8URo1wb+lrvflMyoBk1YEgwXfXnIsKaIE+PSCVr9oybvcZJAMgNK9CqDn6II?=
 =?us-ascii?Q?S4CXNXK1xj/+B/hCyXgsXYxVypaQQvKn1K9NOMu+dBbzEAGzrvdA4kN82hYp?=
 =?us-ascii?Q?3fbKCiXukIwakcKCK3HiP8wRgIgspgGCkDiF0sPN43BoVSfuPziGpWBLlDIA?=
 =?us-ascii?Q?DOqob7NJ57v2GefxoIX75mmDlAsIEDk6Lgx+LYrMRExINuM7dyzsRiogkc9t?=
 =?us-ascii?Q?PwkHM0lg3qRMKZMal6yVj3pKtSIt9R0GYNIgTwaAxivQ02u1MeetrU7DxFYT?=
 =?us-ascii?Q?BzdTlwiiStzWnh+RXAUIdoCNvY1SGRP5tZ/17o9KdmOLCUQvdVMxqZ773d7E?=
 =?us-ascii?Q?jllbPfcjH+yyOW+uOhHYeOKgVZBgWGRKXcHNoLlLiHQFoJrpIhb5Uj/YU08H?=
 =?us-ascii?Q?k5EXrGKpZTJP1I4fZl7LU6CRoVJjTiZ0OvADEKaHjgN6Sclwc7LX9yeR+4Qf?=
 =?us-ascii?Q?FweJt+sZWLAe1rywbm7mCuxNUmpTh6nZ+PWGbffry2rK5pSFsxANUfp8HhIC?=
 =?us-ascii?Q?Yf2yw9qA+8527c4T0y7kW7TXagV/d4vTwkwL8QeRXWPuKgWZVHIKcrksjGow?=
 =?us-ascii?Q?JYT68pl4kAWJ42BvoPKb+ew5Z+5pf/De8fySY8sDZu7k8MK5t9dRoVB3WJ/M?=
 =?us-ascii?Q?KsqFGoc2VgnMNNsxAPk/YbnigJRv8I/gPFFCsXaXf+GR8XGZ3olPzMNrYP3Y?=
 =?us-ascii?Q?2mXcLaL8vIDADj9e/Io+ggHYfAfcW6jKA3EYlKmqBsYd+WxwdPNSHy1pnGBK?=
 =?us-ascii?Q?KIUyvkceR/YEWYK2GQB9oNmi3cEXNVOgIn0u8M8SGFue7tWxr5OQOp076mNR?=
 =?us-ascii?Q?pGZh3hgUxnCBTWfVr7JULg3H6TkdUtuVumrdtbGKeDa7FrXCwdViA0lrszzS?=
 =?us-ascii?Q?oYnA31Fv6mPmIis5jQ5ZF2sZmJ7hdnqlfdw3/mqXk/upjndZxDwUW6r3t0Z4?=
 =?us-ascii?Q?bcbQjqq8JTCXc0vsJIyjf9REXIYiw+V0/hOaGhkUmKVYryUv+jEnVPVi0Dc9?=
 =?us-ascii?Q?uJ/2AJ0X1LVjOT5vHY9H22MEra03fuilgDof7pchFbiSLIlMaZLODItfTT/Y?=
 =?us-ascii?Q?B0+3lLLzp8PAEZ1E8ANuTZcLZpQJq9Pnqtj044uYMX53kj2z7Y9bq6Kk6bSW?=
 =?us-ascii?Q?y3m/jJ671wLF6K0v55eHWjtRjktSK4IxYTMd8pFer2/ZfXAmdsZn6dhLgB7G?=
 =?us-ascii?Q?zdsvvkUDWgSkB6XeeO5p2TRJBl3u49237/s3Mf+9ua4pD0cU/1Zbl9WqOSap?=
 =?us-ascii?Q?8Jb4B752BoFdHMefQpXpwvo42K15HHy8qfqFnkLHVLYrFtgUvb5QX1Y6wzeQ?=
 =?us-ascii?Q?dD9SrQjIzZki+cMvrq6KpdrxMP06j9PaQQ1r93JX0nJRUSUlj9nnb1migsIK?=
 =?us-ascii?Q?sktBUG6KzC4+tf7NSscp8c9DqJm/45u33AU8fypkD61GC55E55wRxVAisM7t?=
 =?us-ascii?Q?a4jsPjG0qXEgyr0J86VpTBN8TFNbo8nm98+X97NC0862rTiblmGcjqok+WMI?=
 =?us-ascii?Q?0Aadtf6V6c65Gh2oncF7rPOKHLykF0RfAa7ng68vW4KiVt8QwaTdlS7Fygiz?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08174b88-ecfc-453a-3b84-08dd92816d11
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:51:13.6442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQ3HKg3hnsPND6++B3+oZkJjsa2JUOoRQPKLpjjkzeFKyIVz+UOPpZH0Eqm/0lwHLjgJIgx1rBoFoqnITuq3SjDzn2mErpnboN6ZMJBrySI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5992
X-OriginatorOrg: intel.com

On Thu, May 08, 2025 at 06:31:42PM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This fixes the ability to copy and paste the helpful meson output when a
> test fails, in order to re-run a failing test directly outside meson and
> from any current directory.
> 
> meson never had that problem because it always switches to a constant
> directory before running the tests.
> 
> Fixes: ef85ab79e7a4 ("cxl/test: Add topology enumeration and hotplug test")
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>

Applied to pending, thanks!
https://github.com/pmem/ndctl/tree/pending


> ---
>  test/meson.build | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/meson.build b/test/meson.build
> index d871e28e17ce..2fd7df5211dd 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -255,6 +255,7 @@ foreach t : tests
>      env : [
>        'NDCTL=@0@'.format(ndctl_tool.full_path()),
>        'DAXCTL=@0@'.format(daxctl_tool.full_path()),
> +      'CXL=@0@'.format(cxl_tool.full_path()),
>        'TEST_PATH=@0@'.format(meson.current_build_dir()),
>        'DATA_PATH=@0@'.format(meson.current_source_dir()),
>      ],
> -- 
> 2.49.0
> 
> 
