Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66F619DFAB
	for <nvdimm@lists.linux.dev>; Wed,  6 Aug 2025 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754516622; cv=fail; b=ElZchPCDFQ/CzTfjYZnTJ6HL4HIEP4HnC9FUNAmA5t7eCAAVDD0jBWSQPSZHJGhqskCWOIqgcY0bXgTweIf+Gksq3MmjbUU77+12PvUo4H6NFySWh6rGbISR129w298AuLIbhZbT/6zuf7I1nlO9IXS5TdoN0a7Cjtyjh4RXVmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754516622; c=relaxed/simple;
	bh=6jbSKctBsJza61oxhAvBYRdcCFnz0H6T3yy+Wnd7Uxw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SNvprzChqOzT3Bqy9bDkzzpSP1Df14rPFjT11IW3bbb9R6jUE+IyEyWLhTlPmqGr2K6LIwdqkuq/fpjX0xM3O+j+H39YtslRTKUeZE1h+154CDHVZDyi9oeJ6DeWueegPDtplLKib2lMIFMXa0ZdAlJRMCCLywh4hVB7zUETX0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fUh002x2; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fUh002x2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754516620; x=1786052620;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6jbSKctBsJza61oxhAvBYRdcCFnz0H6T3yy+Wnd7Uxw=;
  b=fUh002x2qsy6ebTLlZyX22B3gQFMkOkevWAzKththN/VbCBP8nkk9LNr
   /rjc1tLq3WIwVdTxbLYUSUFVz134h7H1kmMbWk5K+N7SRadRxyOI8Uo24
   2O/XLUH2Xz8yVmYg6R4Q1SDaJI/4otXBHkc1e/mPtTMb7quI+h4A1usAW
   kb9yfgI1UCfepoCmWhktb0Q5X+dIDCVijBxuVkCdFMuoskvWL1/OuGMfe
   vcK08U45Qassiznd9xN4lrwFGcpS/jbI8n8v/q4kUqM3IBaZIOTTavKIw
   rQVkQ2NDkBYnIhJlfnUHYJEhbsS+Bpp3OCXFM7aoXUBRUoTuVdhl9tk/i
   g==;
X-CSE-ConnectionGUID: hzGqtQ71ShOrU/N+PfPHHA==
X-CSE-MsgGUID: mAWPk9woTl6AQsKNlEw/BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56987022"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56987022"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 14:43:40 -0700
X-CSE-ConnectionGUID: v2i3bLq5Rz2aSBS27RJtFQ==
X-CSE-MsgGUID: VRTnHPhrRaqQCliT1/2Zjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="188555281"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 14:43:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 14:43:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 14:43:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 14:43:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKwLn2eshgZaa1C3SY6tGhSdx3C4ExSoYVs3HwjUq86I14dcBEsjI7ZJjoXycqNxEUK/+ulgZ2t91a+YTu7nIafH2hYXifH2n82LlKbKTHkj5Yve6W35jdyxF4dG4J8a5ItjkGKoTTEkolghOBe+VLIdbQa8nTR67KSndMpGX5sZUDWaCDQw/gTsgyBW18cNOD4sDIZ74Nk7l+polV8qw5a9yLzj8UPxeNZi45Yk6N41VOywK0mt6mglVoetfZrI6+wS+f8OKtJUDozHNjE6MACExafcHu8JA0MePOxUGWTi9Y2oECqfqDMEyD3eqDnzRbTKZSvjSU3ITBAeKnR+lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUtO8+jcBunOwLzT14uyK5t0+Zj6E3Q1om/PdOLdD5s=;
 b=PeQGWY9ahoXAvo3CpNGppNqbICRzaCEnF5CAT/7g4bxIwVjJUi7votGsMALy+OPHS99sIsgXcNWIk/fNhfC/KsVyfKeHEjzGOdrYKbZ8kg957a8yONaeOgTpLFvJp1IKMAmeFfLjyVgHG40e2VEcPAP2QL/0d/fanEp0Cy0Jvg10xFTM7NusZhHgDccCfTfw54trGudOs8eoPtRVyh4oX/P8Mzin8qZEpqy/GNfeqt07kyH2RCVc0RAY8zUAPmgL3oYLmtNB+Og+lgm+djRXK4iIOC7pOljI5VreW8JvaBJbIBmjg2mvGES1NB8iUCRaRyNRFKApDudn4VumST4FQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA2PR11MB4842.namprd11.prod.outlook.com (2603:10b6:806:f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 21:43:36 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::4e89:bb6b:bb46:4808%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 21:43:35 +0000
Date: Wed, 6 Aug 2025 14:43:32 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <marc.herbert@linux.intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH 1/3] test/common: add missing quotes
Message-ID: <aJPMhH2qQ5Oxgkc7@aschofie-mobl2.lan>
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
 <20250724221323.365191-2-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250724221323.365191-2-marc.herbert@linux.intel.com>
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA2PR11MB4842:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c611238-d91a-45f9-9c9c-08ddd5324bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1BaJcER9qVSUFTrt6pZX2hRiGMpJ1Iz28hcmBJ6SgFbLuwzZfXxM5iZaCyR+?=
 =?us-ascii?Q?r7p/4UFYC7rm2DjbPnXDmtXosByiof+/KNZOw0q9IPxyhqjTHEkwDntEvSJ/?=
 =?us-ascii?Q?eow4xMW0TU/Ik9goX1PDQgIX8PzFbrxY3GndH9lhY0F+FlvzUiZ6fUNPHdY8?=
 =?us-ascii?Q?Vgbr7Tia9pQR8K1XunUTfpA2cg77x6sVlQbsKnrniBA413F5TWHvqRQ9u+SD?=
 =?us-ascii?Q?AwZ/g2+ZOQUvdS7BSBxuOKq7caGGBxHS2ksdhgV19sR7YJsFJzsqakEJI3eH?=
 =?us-ascii?Q?tztziRDeubiP9AfCRBfs68cF1Eve1zQtwa0+Vfv80RK+CRrioG7WZ0dcHYIx?=
 =?us-ascii?Q?lqr4lDAUySPqaefqRMpeW8q6BzD7Za5z+FgjFFIizbEGQ00FBhDYmwcb4veC?=
 =?us-ascii?Q?YVz1a6dmCPtPrAFxkgUIsHNGGgsYNEMZ0pauTAR0T9R54dgF5RMqtgFA0VNy?=
 =?us-ascii?Q?CQ8GSPB/He+vqzYaQ9r3oFn0aWvAo6cYN3pC5m1ZEsusnreL2N6rzLddw0ga?=
 =?us-ascii?Q?TPN0/plZ4qPI1gdSs8K5au8OleCLrL7AP/29KvL0jZwhl80NurbV6mPLffFB?=
 =?us-ascii?Q?SrXLp1nWmsM1x4vIgb7eGYGB++uhppuM8XBMbL3zVlX7yzYEfABhizBICB2h?=
 =?us-ascii?Q?eFGO30J9csdgGJ5Nlx6SbyQdfebd/By6OcCjOBsdytIaqm8V+27qLGIPfV5t?=
 =?us-ascii?Q?OK717H2Yt5NTZY1Slaw7pSH3r/7XPvrBgPydm3N7crj9xqf2gEXqQEo8FUZ3?=
 =?us-ascii?Q?7jDvs7rfA0oUk18emJRwkPJCYaj0uWKP24U5MSsOu6LMiDInycjBNJtWVnd5?=
 =?us-ascii?Q?jsfeJEgPrCvqyJq3QLVOCWlBmR6p86tLHa8i3f1sXWHB9IoCc5M39ABSWfMR?=
 =?us-ascii?Q?irvoqJ9LYR1gms9bJHIAgYa+pPc2rCBle/a68wgH0ny3pMfo39vB07h/3Vyy?=
 =?us-ascii?Q?QkvlwN70Zjf0d3FUPUXdkTMNww9x/KpaNlvS9BS1cKLqQ0juXpQ5nIKETxRB?=
 =?us-ascii?Q?2fdI2ghA3z3Ky8p+wAeD/HsOg9s19dROLdFCWxAGiw7uVsh1dsF1KwUyR9In?=
 =?us-ascii?Q?hlWRl6o2t6ikNbIaZ/qXI+OEBRa7zINepO7mPLuHxCIccvzhmg7Z92mV1Uea?=
 =?us-ascii?Q?/Ws1vDrPaqr568tE0WMwr064slsVT7klN6rqXrFyKtYWyEl/ENCF5UijHFiU?=
 =?us-ascii?Q?jMvpIwZLdejsPcCwi1bhBAeJ7yWyNS3F+O9D/0RpNDTRDkEG3Gs0U78KKPgr?=
 =?us-ascii?Q?qXv7ystNB7GM4vSd3BIn6qV3AF7JW4IYVVnQ+if2gjoM5F/j6/X4bQH3fUdS?=
 =?us-ascii?Q?omZOXr51n7XgzuG0A6mXW6qOHP/SK48CATtEh1Lq9hF9NyMT3rw08vP7Ol2W?=
 =?us-ascii?Q?pSRLoUzDIcyDmAzzUhOZECmvFY7OUOLhcscuOoJCPWpQxIZmOjbBwKKud1Zq?=
 =?us-ascii?Q?p/47wCRKmdk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cWydj9Wy7jvcDNPjQQDQl5UTo8bzcSvsLae9ZCPQe2WXVLWFzsFFZiR9IkqZ?=
 =?us-ascii?Q?pwEJevL4B5t0rog9+E25/XaP2htQF4MwWRsHaBFPbOf9G4mqYPO9V1/qy6qd?=
 =?us-ascii?Q?LRhdIXBpIgEusEB6eICzmqlLBoKZ8nx2RYWJefHC45iaQ+JuyYUwHzpCvW0W?=
 =?us-ascii?Q?X5QqnywcoS3SK7NKt+2ep3vHREqs9IwXiB0chAOP+K87HdNbu/4QEEBmeUS4?=
 =?us-ascii?Q?JSRWI1Ok26DAXhPN82T3qqfMozA+QCGreAdqa5X27gJFQDBtmRPs8DLLAAH9?=
 =?us-ascii?Q?Qu+vSK5KS2CPgclZHkHPhJH+duqaNwDWuDmpHAG01DqAmzCLMPkcrzt3D/jX?=
 =?us-ascii?Q?NZrVt69jBrspil3Kj2AjJySOUbN2BVGNlxjaw/VXQO/eTuI1i25cmIO3p7yi?=
 =?us-ascii?Q?vS28bYSGfMUjzRqiulx+KFlHOF8RS1+KcnU2HET5ybQ4nbEnZnkbanSjat2w?=
 =?us-ascii?Q?VKsfr+WofPCSTsI5gtaU5DyuM6yCeM59u3wrd4k/bHo8PlhOQHZjTuYXyf+f?=
 =?us-ascii?Q?6i8FkHH2SQBlJZxwGFIoNzxTFF86edTTOx2CnF92DCjye8HG2El/vD9RztKR?=
 =?us-ascii?Q?IeVk4xek2X0rCivR9Y1BzR25sNLSLh4A05JpFiOD8m+FfB3sOcjplWOtWivI?=
 =?us-ascii?Q?pLb4QOxr0hRf5d/jzFJ3TQ/4MkmnNlz+PgVmeR082WVxmGH+JBaDUGefiN6R?=
 =?us-ascii?Q?ehOK9Kdh+TlmuWMkKreimEoZ5xgbTiss1Ps8hBNfbs7JezYpUTek0xSVlAih?=
 =?us-ascii?Q?8ovjOSzmoLpN6KWFexAFR91ypU/q1+aDvl2gGOW5RrBrZZEC65rYS+W0S50T?=
 =?us-ascii?Q?lUGd2TJPspSvc1abfM6j95umz2prHxznPc5Pov2SSwIWiZtvK9xxOxB0o5F3?=
 =?us-ascii?Q?4SfAOYGhnZNrKrIJq8oFIsDXVEWtJQYFfjCAHSgVyry8GcZzDkvlej7wd2bU?=
 =?us-ascii?Q?LCK2ilSZfo4AskR69331LaNGE+QFXIF1NYCxclIKa85d5TsHK7ylVzhv+2tL?=
 =?us-ascii?Q?kb2y1iF5GfTaYWB2jrmotKqfbdiVFPXhweXeIOx9V1N3DCsK9kmsZ2kOzPGt?=
 =?us-ascii?Q?H9NM0Ij7DFUQCU0YPWQmsh/7/hqB+yDCzq5pxr7FVePTsLjkBuM3PZGKmfVw?=
 =?us-ascii?Q?SaRlMubUht4ykPa2uckD4uopG8DSWetBtigdpNGMEHMHL0DaPP+UwMcQ9jPP?=
 =?us-ascii?Q?xlFZanRE4QOCOdl7T79jlYq4LkOa8DI+TpnzzaxAB4crQRzc5t65Atyfpq/5?=
 =?us-ascii?Q?cR3sW21TGzb4Pg9ziE3KEbOv00HbF0T1oDKFNWgpGYbtT5ccjkrHgLd4Idhj?=
 =?us-ascii?Q?+dEwW/0NQ9iu+zXL3azkRjlVK6uuMNTyQVU8kiXyz/NHhdqSvDto6WvyyM0y?=
 =?us-ascii?Q?ittxMlEBalx1B8zBLuAgduHEnjdREj7k4ANm21CW0huBCQOylN9kB1P14GMl?=
 =?us-ascii?Q?dArpF7QUkfET6bN/ooYAalR4xuZ+JGP5SK0IN+GvSCc4/3wM7bqxMg6xT4at?=
 =?us-ascii?Q?m2w2HBRMLKLEVGbl/oS1jB/rpS5Ji+xZ1iZYHFBV07w/p3NukM8jP88kuM5J?=
 =?us-ascii?Q?+bbx0H+kJ6s6LGxJaBXZ8nbb0ehpYur2R+VN6J22DunNjTDhQ+1InADbXLer?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c611238-d91a-45f9-9c9c-08ddd5324bea
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 21:43:35.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmHlr9UJmy6q1EHRRN7ZELTpJnZGhK0oFGVrasQm04tsAvz6ke9LO6FBFma4thh7Wv+ORODml6WYJQ8ptvn+K9hCzcFQ3RxpM56Z/MeZWbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4842
X-OriginatorOrg: intel.com

On Thu, Jul 24, 2025 at 10:00:44PM +0000, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This makes shellcheck much happier and its output readable and usable.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>

Thanks!
Applied to https://github.com/pmem/ndctl/commits/pending/
with [alison: edit commit message and log]

> ---
>  test/common | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 75ff1a6e12be..2d8422f26436 100644
> --- a/test/common
> +++ b/test/common
> @@ -4,7 +4,7 @@
>  # Global variables
>  
>  # NDCTL
> -if [ -z $NDCTL ]; then
> +if [ -z "$NDCTL" ]; then
>  	if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
>  		export NDCTL=../ndctl/ndctl
>  	elif [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ]; then
> @@ -16,7 +16,7 @@ if [ -z $NDCTL ]; then
>  fi
>  
>  # DAXCTL
> -if [ -z $DAXCTL ]; then
> +if [ -z "$DAXCTL" ]; then
>  	if [ -f "../daxctl/daxctl" ] && [ -x "../daxctl/daxctl" ]; then
>  		export DAXCTL=../daxctl/daxctl
>  	elif [ -f "./daxctl/daxctl" ] && [ -x "./daxctl/daxctl" ]; then
> @@ -28,7 +28,7 @@ if [ -z $DAXCTL ]; then
>  fi
>  
>  # CXL
> -if [ -z $CXL ]; then
> +if [ -z "$CXL" ]; then
>  	if [ -f "../cxl/cxl" ] && [ -x "../cxl/cxl" ]; then
>  		export CXL=../cxl/cxl
>  	elif [ -f "./cxl/cxl" ] && [ -x "./cxl/cxl" ]; then
> @@ -39,7 +39,7 @@ if [ -z $CXL ]; then
>  	fi
>  fi
>  
> -if [ -z $TEST_PATH ]; then
> +if [ -z "$TEST_PATH" ]; then
>  	export TEST_PATH=.
>  fi
>  
> @@ -103,7 +103,7 @@ check_min_kver()
>  #
>  do_skip()
>  {
> -	echo kernel $(uname -r): $1
> +	echo kernel "$(uname -r)": "$1"
>  	exit 77
>  }
>  
> @@ -147,7 +147,7 @@ check_dmesg()
>  	# validate no WARN or lockdep report during the run
>  	sleep 1
>  	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> -	grep -q "Call Trace" <<< $log && err $1
> +	grep -q "Call Trace" <<< "$log" && err "$1"
>  	true
>  }
>  
> -- 
> 2.50.1
> 
