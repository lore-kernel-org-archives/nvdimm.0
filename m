Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96594349CC1
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 01:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785807496; cv=fail; b=bco4zBt+nAip6MQJvHfalzTb82/Mfr/PSPK5OuSVTv3Y1D4nrbx4zTEOdlcGv772aCoLAwciQBBhVB3iI0hh7S1jGQsf2oq1mkJyF/yAjQVpirmkzFl/EMHUl7yMfpUmAg0+jCVh/7HazciTXvXjCc+zBXul9Ex+ABY+p1rn1sA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785807496; c=relaxed/simple;
	bh=UigP1Vxa2PaQ3DxLDb/tKvSCUoO2YW8yRqMnbwOQVOk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m9AITKkbjQAVk8utU9Ec5X+jTTWzGFnx0nMkH5WZ0/u2ll3iB0hN09LIOzHzNI9kTT+JC6ZVGopzeJ88tfiXOP57DceK/Zj6/bq2H+wHZJ/XaU5nNZ3JorBJsZSrBgNZysAaYlT00NdWTKqUdAtpscDOWMkyfZRVBQgVp7hN95s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g2W2ueuJ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2W2ueuJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785807494; x=1817343494;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UigP1Vxa2PaQ3DxLDb/tKvSCUoO2YW8yRqMnbwOQVOk=;
  b=g2W2ueuJ1CTBB+eTrpMXnKE84xnZR9FkRxcjBR6pip4Nswq3E1fViU3L
   AinXsujOubPcy8Lx57TpH2IFkS4yt7kEt3pA2kt6AU775p9SAfn94EhUV
   1uWVNh7fhmjsPPTRpcocJdPdsDkgse2BLcndU7U4S/YRyeAn+3QhVgAjj
   azbJdy63jJIitsnC6YyLOFoJCpb0GL9HakpnUirdhTv9Uam4mIRgGMr8g
   EfwkwtEl6clb+UBPBw/D7tIALPesnRyYHJ6DL8cdiZ+IIQVj5AdHsmrSq
   6w6BjxBgcE1oG7hT7Apmgbm6x41uJwZfHTeFiu7Wkkr5hdoFtVlak1QTT
   A==;
X-CSE-ConnectionGUID: ZMSUJlqtTTCBbFAHP0/OkQ==
X-CSE-MsgGUID: 99ZGchgxT/6OmdOgkmXwNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86472835"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86472835"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 18:38:14 -0700
X-CSE-ConnectionGUID: G9AmT650TYGWNBUOQ35e4w==
X-CSE-MsgGUID: 2zSgg0bFSy68iN/3FtZSAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="255081757"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 18:38:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 18:38:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 18:38:13 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 18:38:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRY61OgSDNiyy6cmP6Xf4LcSKzRVsjTztDQUAdZ7V+QJb0/H5FyQaylEDtok5AztTvaVvvuo3DpVP7aFxvUkpMDfCzBzpoI7cObDbrhAWxQc/pgJRdYVPfKghcE1oInABFnztsuoF8ybJij8dPX+kiv9b4UgV/JJiSFoic9XEeV8e38+LBS5sTiVWRRakz42DYBG2y9KRmLNHxsLNTeMW0DKODtYdyGM+5HEcDv62aLhsAN04KBgYa6BTQwvtgSb2jDuuze2Hl7rlMv6FYdYxHbU0zblBfM4DxwzW2JZIy2siycCv372XT90FN8R5p0GaEX5VbKBfc/awZP5VDlTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxocmfkHg7fksTcYhmLqz/vFGL7jK3z1rvuVHnybDO0=;
 b=I6TJbSLPQnp56ikN8SutdurGdr1VjdZvCCbm+3VQkZKX15IfTtjljd1vrjzAmDTr2+8BqEbNoumqrE7PrOuX21jqST5kT+cNwLgfgxZlFczYBfljAmMKNrqB3hSFiUOVBLT9FvTTH5OJJ4AzQpRonWgYRkdlpPTg/KwjoGxFZZ1nxvsOH5pXJPGaErmFHrjsTZ2pymKNawtrXX1i5bq7i9B+7bpkfkgtjwI76e/0ZwsT0NWvABJ6QFD19TgE9T0P4/6QIpulpK1SS72Bm01bD/rUEiuYZ9Sk42JfmTBlCDeqbsb3Gk60m/j1TGOH17xclklnopOYmJzhsdM2fT3SwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY5PR11MB6187.namprd11.prod.outlook.com (2603:10b6:930:25::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 01:38:08 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 01:38:08 +0000
Date: Mon, 3 Aug 2026 18:37:58 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, Junhee Park
	<jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v12 8/8] cxl/core: Enforce partition order/simplify
 partition calls
Message-ID: <anFCdsSo6dvxfFrZ@aschofie-mobl2.lan>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-9-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-9-anisa.su@samsung.com>
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY5PR11MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: a8950138-39ea-47db-de51-08def1c9092c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: XrN7sEMBIszRvM/bGmyELT3wfAzmEczY5O367ZDNygFsckvImoWKeRMGyWL01+z7BydEILuvrPvSofMnEq6fFssZ9fxulirqos2Q4wGWtXy1u6GKNlDB3YodaSkpsEm3UZgrqD1k3r+cYTyhE/DbeI4Xo9kfGFB6PtFZnvquWg9jYguXRQnBkMcXIX2xke0dPaIoM/Ui8jEoufpFGBpmjgq8WxnGkuGUB2A7sk1s0fcyIWbo7geDkw+iEvXobKjdL/XmrJnDFJB5KjyC/1AROijGg7sBMqduW+nPtLx3FV/iIInKI5okH9wazVIAWz6JXgIVyYKr82a2YRYkXx1EUE/BQfc6Fl7zIml1Px+ubQe6SW0fPJHJRbA8JXhBaE/JUX10Caz2MWE56E1onIuBohYlT/muICM1GtF0UOUqIfCaMY0+iUGBykN5IBYMX1ymtutWJlD5y/GV+GlWx2xFr5Uj4YKfr1zJwcI+8iPrN7/4FfckauhfI+iOPXHATNTDCKmeJPAgYShNmNooxZKZm/tnXg/EaDm0qmvb1xbnFyLtuLmgEjdVievh9/ZKPAG4ACHyq1J/Zkx4vLxAuNJSgeI8pHiF6Q5v8IjYW+VlGpMC5f8HzGAdgAYqaOJBU8nVFZkULTEDjqzifyY1B/qxFXWbjGeLsaBJTngiAsYqi18=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AdPtLPpx2JDYnwc6G7O80PYx0Fqa3pVClw6K9EjF+kyAvqvtWiHVe38FvMqT?=
 =?us-ascii?Q?nOlPgmBiZB9rfhP2sxh1Fp48iGvIESQLLQSqCq49P2GhQHpYUmunjwXxv0S/?=
 =?us-ascii?Q?sE0kT4s4M0I8U7b5cqHmfD1CDUpb8bN1gUB3FLsV/4rTR34CiZtev/fbWTkv?=
 =?us-ascii?Q?vkZXSv9r7nLJbJ9BUmrMOoJ0guvuTvmb1of3EeKWmcj4WG9GlvAQI+5STOf+?=
 =?us-ascii?Q?AWQMvGOBOa9Ilt5b0kalefam3QT5yHmDRUb1In12WQm0Hu+hT1JfNK9hpMsr?=
 =?us-ascii?Q?iRLXwWiTo4YVZP5teejHiGXwKk1pJnFB1Nbvi4cEqjCF4nvDw73R5GbvuFDh?=
 =?us-ascii?Q?BaoPyHI9lqwrctpRiCHwNUyOtxzQv7mjes1bsrLS11ip0fSSeIRZDqWSAg0s?=
 =?us-ascii?Q?l3VtdAGslhEGdlUA7FJ8zNaC4w86fwDqiEAnSJNikpOtaZkF3HVPJu0vuhZ2?=
 =?us-ascii?Q?tkn7siPHDXqO1R8+pXK51+xfTrqBsxKt8dTM9wNW0YFEC6fNpw+wSX/bT+lk?=
 =?us-ascii?Q?U2dvFq0VdYiAD2TJFZr6d78ApEG6dXLKNejnIXCuuUe42L82x8S3nOOandE9?=
 =?us-ascii?Q?tZjt78kzc3OkSkT7zzIf2yOjryDQ3S2wfNW6xlxp7UdK+2QzyTpacJ2PJSTv?=
 =?us-ascii?Q?wE1/eY47byFiQopp0HnUgE+dB88nq1+IDPSHuO/NUSPl0jhC3DfH2TdWlztL?=
 =?us-ascii?Q?Tl5x+4ZyCUCowTeL/kX0JHoDDZKOe9k105iwBMzic7KFjgzmc6Et1PSRT/AI?=
 =?us-ascii?Q?EmHnCn8apZUM2OGamgAvjs/siwTD5ySPSAofbQ9ZevkMNsWiThjN/RWSMVuv?=
 =?us-ascii?Q?iu3Ef/0DWz/nA12jBRvTU9DM8Vev3zJO32IXphIkPv5v8IrmJ2UzZFe9DvhE?=
 =?us-ascii?Q?hummoCQBvPsimtOdahAW9XpT8LKjmXc+pXB+FYMJV/XzhZBSozS+GW+EVmlV?=
 =?us-ascii?Q?zQpE/+Ys5KYq+86fHEImRoEMOHYm+59aQ4rFDK66E5UCGFNORwNH6kmZu6Kc?=
 =?us-ascii?Q?R23XUMK/PyZVWu8Obkj0ThmLzmzpbCa9Bdy/jOhr27/SE9Fcyr3bRYk3DSwf?=
 =?us-ascii?Q?SHo1tGadXtwyVFIOK8bc1VvqGR7E0pk0Qna9rLnSjvjbscIpyuDNNSfYkbqx?=
 =?us-ascii?Q?Kn63gWjHGGm3eGKgO0PtG8GG6uDoWfmc999qyoBGVcrnyueY6t2zIXgs6TfB?=
 =?us-ascii?Q?hxHyDNNAGgVLskfcOz0Z+AO8QK+eIutfXqmS/Kv5Bx1xVqJR5Wz9qgJgJ1Pe?=
 =?us-ascii?Q?VOpfJVUnBZ9uxScFOn+G/HlV6N+GtIErHV+UK8OVZigRHP/7w83S7KSvtCjb?=
 =?us-ascii?Q?bHHfL0jsPkyHTV/bAGKMZ4cUuyQTxtjqhX0RhaSVIjpFYDEwcL0fSRbd1l77?=
 =?us-ascii?Q?AKqoaI2vECmfktcND2oBKYesvYETH8fnC7LFQg58AWhwy4mjMGy4E5Dh8jWE?=
 =?us-ascii?Q?HCkWOzniMxImYCEGUMLWyTnF0q7VApCKajMMFqLH9VFh3yjxgQo2uNVWj4Sa?=
 =?us-ascii?Q?za3x1jfPTyHm1fkIE4cSSbUD/F1eX/mcJCDZld2xTo7J5Q6Uo9d9NR6dFTG9?=
 =?us-ascii?Q?nQU45Y3uPcQYksMjvTNZaUflZZ39ushwNdUmV+NcSFIUNXFc8S7DUGxpZh81?=
 =?us-ascii?Q?CF61ARoTA5K7GedpK4IS6SvPumlExXJfxyouglxZLPrwzpepdgz2oTvtsmri?=
 =?us-ascii?Q?oWxPwMYIAGiScgRT68OTAz6jTxS7h3Ti4Au7qygNm6Q0OGyRdcOJzHK8Syve?=
 =?us-ascii?Q?qJmLptR5Rr+dO63moXDoGEwrISuP85U=3D?=
X-Exchange-RoutingPolicyChecked: ZKSvk1YEgfM2wPb7uOzVLDKM0qArz4Hc1Gw83KszLVOHdJmUZ6aVdCiuqj5cuanqzd+MIo/9ArcKNCHdwi8Lo/PVjH3JK7slM5ApDfKGQ746O5IazGdzZLanP8+47g2OZTAyvTGEYCvsjJNxWwbYypcxJP5Xm4IySAWTP3zXDN4bmTUf+oRkMSQDBzMbsvmKACjsoAuMi3UORdXYWFKJi3KceSam9yGzTy2CWXM+0wIDw1AnQLArooB5X5t9gkNCvaM3YgnxzIC1pJ5kWu4duy5Voz9Ay1ouUWzKwFliI+WMdujUMCBNnrJpHxxKSfHO+0oUEjY7zTMg8+m0r7J2PQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a8950138-39ea-47db-de51-08def1c9092c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 01:38:08.1480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekKxhiqSOtIH3CZDN2ra+4F3q/rmpS8ICW7dkPiLRR5lYwS8qfSNe9ekKs28AN6TCwx6fkCzVST9kytvxxkUNgmmeJklh9pamL6m7alurdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6187
X-OriginatorOrg: intel.com

On Fri, Jul 31, 2026 at 01:48:13AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Device partitions have an implied order which is made more complex by
> the addition of a dynamic partition
> 
> Remove the ram special case information calls in favor of generic calls
> with a check ahead of time to ensure the preservation of the implied
> partition order.

Hi Anisa,

I think the changelog needs more explanation here. It says there is an
"implied partition order", that is made "more complex by the addition
of a dynamic partition" but never explains what that order is, where it
comes from, or that this patch starts enforcing it.

I jumped to the diff thinking it must be there, but nope. If I 
am remembering correctly we've had ascii art for this layouts
so I'm surprised that's not here.

After this patch, the code relies on the numeric ordering of
enum cxl_partition_mode. That seems worth documenting, perhaps alongside
the enum itself.

A bit more below-

skip
> @@ -457,6 +457,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  {
>  	struct device *dev = cxlds->dev;
> +	int i;
>  
>  	guard(rwsem_write)(&cxl_rwsem.dpa);
>  
> @@ -469,9 +470,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  		return 0;
>  	}
>  
> +	/* Verify partitions are in expected order. */
> +	for (i = 1; i < info->nr_partitions; i++) {
Just 'int i' above. Sharing that index is not worth the extra diff.

> +		if (info->part[i].mode < info->part[i - 1].mode) {
> +			dev_err(dev, "Partition order mismatch\n");

A bit minimalist err message. Do we have more useful info to add?


> +			return -EINVAL;
> +		}
> +	}
> +
>  	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
>  
> -	for (int i = 0; i < info->nr_partitions; i++) {
> +	for (i = 0; i < info->nr_partitions; i++) {
>  		const struct cxl_dpa_part_info *part = &info->part[i];
>  		int rc;

snip

