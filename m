Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775AE2144CA
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730306200; cv=fail; b=DFGSRK2T2ceo+vgUkloy2xHRd+wfkqOjKMLoqhs/yyyws/ZvbdtMUhdLZrYtJO0kMlnvs4M2Cv+LiUEaWpkqXGRgTr0PgIx+h83gz/i/GJJyikbgR25/s2STqqsuCU+GIALWUxDAukxBgkhwjVtRtMdNYhjs+vSiMb2BCyK73vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730306200; c=relaxed/simple;
	bh=CPXItN28h3Wf/ejqrJEhdaKOAtFYVVo34pKr/iZr7xA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DCSraNIOMMIXQy7c7oiguqt4LpBylDxTBJNGcmstOk99VeWK/WCI0pghwdq1R50onikNb1v84OTdSOo/QS6QT+rAUL2H1UzHsFYSMH/OZSgP12EMZlIdyCOBGhm2BewUxG6vQgGQb6HNM3EPGwl8yeK6BoGpEQ6FRxAGe1im2Zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOzbMI1k; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOzbMI1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730306198; x=1761842198;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CPXItN28h3Wf/ejqrJEhdaKOAtFYVVo34pKr/iZr7xA=;
  b=lOzbMI1kUWDnFt1mVsooY3uk4oKQeC2ZbvmnltQmjyV4ySAJfIT8MMFT
   lVb1CVC6F70l3a6YvKDdagbwm8tmzByEclF2zD0jFaSfL9tLDoIqWxpJ9
   J4adV3jHJA8J0fG353tLbNd9OXcqAKrW1Wmo0LVVca5oP6VmSduQFTWqx
   OvcjB61yTOazPVkiIk5dt5KsOzgl33VpoWNpMXv2EYjeQyrJyeS5orH9d
   4HGvecCV+q9HWwIlw+d/EvZA5MI951vMxSl3Kf9PWkOhrS+HUD6HLXz8k
   i5qyw6mpfSsh5yHun4I74/6wHS4CGtKnJZ+fhZX21w0hbsik4di4psyde
   g==;
X-CSE-ConnectionGUID: qi66mY/eTOm6kRhqvE8BqQ==
X-CSE-MsgGUID: j+aMkaROSsS8oP0kBAB/xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17662864"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17662864"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 09:36:38 -0700
X-CSE-ConnectionGUID: ZBqKHG5ERcOkRHKnEJWw+A==
X-CSE-MsgGUID: RLzOSOMQQKe7Rh+QD0lBOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="83183282"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 09:36:38 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 09:36:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 09:36:37 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 09:36:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DlOzd1SXiiZpfkgLLc8RSl/Q79Gk/twWubDoQwlxy6f3zh6vRcdCNwAJfeAyJDvm7W4lEXRumhP3NdTtvJwPCgWqmXvz+bvRshN0gx/FLvi9QG/1i4x3PB126iUqG9Wat/0uY4XSG4aJfkX9/LqCB1WhSTpOkmelaE7SUEbqffO9kbtofpb4YjdneKl4FzsEPHP5QFaUxaUxCJzh8jaCzJ4jI7xHGt+jElDdI5CatzxsTsydsq5AUxxPIc2cWdf+5gVzXww40Ir4LO7d66hiE3z9Y3iukGm+80ceiMK8POkNZGd37LhoDzjiImPqQ/728X2K1nMd8pirz6YAzaSY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tdl9ZNGbuVx3zOfwPVCxHE3CyriSg2BqSm0sP9b6N74=;
 b=v+v5Ze/wTwcioWkDbOPZs+yUc0IOUqWjkSGyDICc4XCXTywBwPuwB2PTuOxc77NrQKydaC2CC2+TWnA0iyLDyWNSWeekaRzyy6qv3TuJIdAATP01bgjMypYdp34DasZ5kSszJqFbsz8k82iqoWHSQN1Q6ixEndGxJjtsABUnJJpm9R4osSQR0VuzK4hjSTaR18gDo1kBeH1bMdPL2ipE8jVxClegBQB7kwlJ5VK+tGNPkZYVJ5vIm1HO5GMdO6Gc9X0tgnN6aH3ee8A+r+vdEQJcBI6Iw0oVcvcD9pG+8ajCL84j2jpiGO9PtI+V/4XZ0pcKet0hHTwyOirlsLF3DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW5PR11MB5763.namprd11.prod.outlook.com (2603:10b6:303:19a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Wed, 30 Oct
 2024 16:36:28 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 16:36:28 +0000
Date: Wed, 30 Oct 2024 11:36:23 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 20/27] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <672260877ccb7_483142942f@iweiny-mobl.notmuch>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-20-8739cb67c374@intel.com>
 <20241030143232.000013b8@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241030143232.000013b8@Huawei.com>
X-ClientProxiedBy: MW4PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:303:dc::30) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW5PR11MB5763:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb54e2d-dfeb-4071-1470-08dcf90100ca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+9URCz/6Ta7nZaFW6az4KkD9UNtEktO0GLgVpsd5YIV6TkX3p5h6hNAeZrhJ?=
 =?us-ascii?Q?I1+b5CAlkps3dJvmbNiaNv6P8cmZuW5JaDZMAQP9F8IRGm+shDcPrqThfjXa?=
 =?us-ascii?Q?mJNip9WV/HsPWs57WvAYSmzL+hsAAIwKP+ND6MvvFOTDxuhfo7HW31+rOwa/?=
 =?us-ascii?Q?+kpKNt/ptu2GqCOGJyqWBXSBh46VW1+3EiNasKzR0IrPLY4Suku4skAmr9MQ?=
 =?us-ascii?Q?IiVqcKwfAP86Rr5HMJYpfW4pq70lM/k5d1ZkXTT3+ZUvz45gTe6fI8yE/PQJ?=
 =?us-ascii?Q?LsD7vgvU3Hk+GHG9YvE3QnbMGtf2voRk4Xu15EG0dDQIyIahj9sTAN9+wZtz?=
 =?us-ascii?Q?aRW5vVhmHEbISmAbuEDMXJpePNKU8Gxz29RPwR/B9W+ZCUEbv55A1S6I9rq6?=
 =?us-ascii?Q?2kGLVqoEyddecQK8ESe20GwDygPoqLMoJwTzuOvKWalI5klc/LtbtxOBQlfO?=
 =?us-ascii?Q?2gmEQS0EKzpbH/LTmHGUzSioCLXYKSpP/1O2vtdSyXBInyZkaTLdv8M+5UBX?=
 =?us-ascii?Q?CRwi5YfnkxfGQ87lQyBCAKgi1bVEqi30QbVxWSXzHV9c+kz0V3krgAxCp76O?=
 =?us-ascii?Q?ZKHgfk+mI/H8BdJ+X++dF7KvlDObG/BoLEHbwvtyJx1vWHURSExxx1cShfY9?=
 =?us-ascii?Q?1Dv4mu7RlUg2hn9OByCsWQKWfIcoiokvve1UHL1XhmLvxuH9hx2iUn7ts02z?=
 =?us-ascii?Q?ml/f47CSRPROF19JOYHRS7nxivRN3jp6OifjNMXG2Ooe3P3qLtfJTv2PuAsf?=
 =?us-ascii?Q?PZIGafzvuw801MIwSfWcxl9oV8kWAPS3jpJpjf++gN3JRWOONXhz0hxfP2mp?=
 =?us-ascii?Q?DO0ILdiqL40mzvY4zdOR6DGkAlEQaBATv3lg8FOEDbLIfjypMCjgSxXYudv3?=
 =?us-ascii?Q?HZVkGC6cdWevtBuwzF7ahJif42G2lC79pCWsOfF9F4TFG+BY771LBU/nvNX+?=
 =?us-ascii?Q?Ape0ALM3ZaccbY2ILnYeJ8jbb/7eirxPKxTSMUcYH/Rw0jLOd5dQUIrkWjEs?=
 =?us-ascii?Q?IoXGXFXwfdQ4OgiT76zwOP6ZHrSnwVDdvtobjPQBjvKH53BaLN9AmuMShLC7?=
 =?us-ascii?Q?vfQzYNucSuSpopSY5FGJJ8mssfJDnbU1rWtVqgjWgBjvJc+jWLE3rQzEevq8?=
 =?us-ascii?Q?a8/JsckceXWyV8NbLVOjamTwkuYj6ay3rTpGxjL4n/LQpFB24TB6DsjG3m+t?=
 =?us-ascii?Q?YTbWgUnhSywLbL1MmdSrQ8GNF8KPlAV1ansQ60bKI9WHEZSQ0alTtmK2jvai?=
 =?us-ascii?Q?l6Tpj0xxHyzaj52RmO9/KTSZtUBEwnA49WJ+154OJob5IDQNpVB5Imx8k8mg?=
 =?us-ascii?Q?Eqj5HS8xBfKrdhd59wv9gtIt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6U1BqX8YpV4b5e43bSoKsSkn6B3BuuafGvTJ9J3fXFb0CKXm/WqCScqb0pvN?=
 =?us-ascii?Q?vBX+DDZMgkbr0UxQZEi/KAEigRZQ0FN2Jp8lbMXor1jG+t4JFWKqc8353byL?=
 =?us-ascii?Q?4bHcPB7EBCABy3BrG9fcdz16t5JD5F+kHyYnAxbiIbrDtU1eIotGV7TPVO0k?=
 =?us-ascii?Q?KPL6gCRAkzNB2RKejgbxPCEuebB0qArWMZWELvB2bj+9IkGTdpY+tw7koGUj?=
 =?us-ascii?Q?kLe/HHc+x+xzvaOV8UYV6MX2WYZpxDZfpgp4PbBQ6ijqkBxt6J/B1H1zWNWl?=
 =?us-ascii?Q?OzyBcb/ywt4UmssqAm2uttysQFO7bGa55bLG3OLJ/6fko2OiTRr2fd4zayA+?=
 =?us-ascii?Q?I+OpEVkEX1Qrs9ifvwCA0Vv2y9yW8SChBtB7GDs/ohDE+3v5Ujsfz7fHp0a3?=
 =?us-ascii?Q?LMwTOz+ChTpNwM6F0x/ZMlRZeYTQvVjrZrr5KcbDjkmbBn84FNjYa7djeE8K?=
 =?us-ascii?Q?MiXUmnU57m5hsTrUCyV9gEBUmDe2fcEkuDKOwtHKkC+CdFXyqWmSLqJbaVw1?=
 =?us-ascii?Q?mvOe2qhnAqAcqFAVmtq/bFOrxNBdY5u+LU115jyf0Jhf2IMFz+nxp9UJWXlx?=
 =?us-ascii?Q?/UT39cH1IIdnY7vNRIPbuq3VJsZOWP11Bef5l8H1KgxYvXh5Pr5xApSDKwJQ?=
 =?us-ascii?Q?mGrXQ2MVjx3JNVRfa2fuzTj+sSJsMSyexletBcw7ipINR2kwUDpo2Njwim/F?=
 =?us-ascii?Q?LmVd0A3+5wG9WVgzMv18jZlnxAmLo9NUxUrX/ghA93iHvbL8lHyLlUJHOngK?=
 =?us-ascii?Q?tQZtvdEPaEvqNxqBAjq8nf4yjRM+3GoqW6Z1UFLjcblL63Pvw4oOBKrG4lHW?=
 =?us-ascii?Q?3ke+gB759/Hev/WKHzQwlRH7uGGYdlXlKP0C0o7daAlu4FNnKYbx4CBk/6bm?=
 =?us-ascii?Q?4NAIMtYPtKoxbp4fzts10H+SQC4+3bDmyOXZijS89tiO/v3rREMYPoKQLd5h?=
 =?us-ascii?Q?CTxlawo2q8s+Ix+u3jiTaL7OYw2IYuca7Maeg73aOhwpynn3CT2A2KRPNKtN?=
 =?us-ascii?Q?IdlDc5jc/AlNkJImgfdiYPMW7WG82iWyr+18yX+T3ZqSQEBERS8SepU2Z/Tq?=
 =?us-ascii?Q?vp1IgvXhFa5ResAJYZN2yZkJCXE0/+E8HWJF1ldm2ChCZerLAiRa0RyEqN+8?=
 =?us-ascii?Q?GZ6Jqs5YNIOp1GqEkVqGWkY6O6LdKhhcb73YX1mv7WoROYBDEb+8VdzPXroN?=
 =?us-ascii?Q?E5z70+MWbzwYekJ+y8/muMjUV2KEBICsDOoznqe1ORuyqX3hFDyNZXzRovMU?=
 =?us-ascii?Q?xqyOYCyYp37BXQa5yjBjvJ4CzZcuqdNDhXvr7j/ROvHisubHEOgGWOiey7kT?=
 =?us-ascii?Q?WmaGgQfw4zmMjlUcptoyrNzZoVe0Pa2ap4sjEo4VStpieaAhtXldyU1E3RVP?=
 =?us-ascii?Q?84tBQLzlirtRr60VN+xGexYTpNXvXmz9Z8pvuz/EYTsmaf3HHrPYb5BnBBPU?=
 =?us-ascii?Q?t+xXZId3gXg9hDLGo4mzKBF2iLhbDE7uk50tgICJ+3yHOR4ylRpLM0fLFJGE?=
 =?us-ascii?Q?fvNA6UAyt9nRQRmbyurovU1svNt3Ih5lOJagtKjEdzMhIouFDimcomplCfyB?=
 =?us-ascii?Q?VqMWtKuyWbI6WhPTRNmHfF/wweggF95pR0yDHaCa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb54e2d-dfeb-4071-1470-08dcf90100ca
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 16:36:28.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6h3JhDTxcVbP19bOOES2+a3vU0Gwr5DLCNudFTUCm+ee+K0pradkZMNy37vuSTWhL2YACfqi2j2njIh4X6iN1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5763
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> A few minor things inline from a fresh read.
> 
> Other than maybe a missing header, the others are all trivial
> and you can make your own minds up.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huwei.com>
> 

[snip]

> 
> > +static bool extents_contain(struct cxl_dax_region *cxlr_dax,
> > +			    struct cxl_endpoint_decoder *cxled,
> > +			    struct range *new_range)
> > +{
> > +	struct match_data md = {
> > +		.cxled = cxled,
> > +		.new_range = new_range,
> > +	};
> > +
> > +	struct device *extent_device __free(put_device)
> > +			= device_find_child(&cxlr_dax->dev, &md, match_contains);
> > +	if (!extent_device)
> > +		return false;
> > +
> > +	return true;
> trivial but could do.
> 
> 	return extent_device != NULL;

Sorry I tend to be more explicit...


[snip]

> 
> > +}
> 
> > +static int cxlr_rm_extent(struct device *dev, void *data)
> > +{
> > +	struct region_extent *region_extent = to_region_extent(dev);
> > +	struct range *region_hpa_range = data;
> > +
> > +	if (!region_extent)
> > +		return 0;
> > +
> > +	/*
> > +	 * Any extent which 'touches' the released range is removed.
> 
> Maybe single line comment syntax is fine here.

Ah...  yea this is an artifact of refactoring.  Later in the series the
comment becomes.

        /*
         * Any extent which 'touches' the released range is attempted to be
         * removed.
         */

So...

> 
> > +	 */
> > +	if (range_overlaps(region_hpa_range, &region_extent->hpa_range)) {
> > +		dev_dbg(dev, "Remove region extent HPA [range 0x%016llx-0x%016llx]\n",
> > +			region_extent->hpa_range.start, region_extent->hpa_range.end);
> > +		region_rm_extent(region_extent);
> > +	}
> > +	return 0;
> > +}
> 

[snip]

> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 16e06b59d7f04762ca73a81740b0d6b2487301af..85b30a74a6fa5de1dd99c08c8318edd204e3e19d 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> 
> Is the xarray header included in here already?
> If not it should be.

Looking around we have been lax in this behavior.  cxl.h does not explicitly
include xarray.h either.  I agree they both should after this.

Let me send a follow on patch to add it.

Ira

> 
> > @@ -506,6 +506,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
> >   * @pmem_perf: performance data entry matched to PMEM partition
> >   * @nr_dc_region: number of DC regions implemented in the memory device
> >   * @dc_region: array containing info about the DC regions


