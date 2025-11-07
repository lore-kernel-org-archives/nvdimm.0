Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1E32652BD
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762532470; cv=fail; b=X16xCOTkY06TvX2qsp1Xu5Hy65vls/IgyGW1a4POMIaySLzp046iDJobb9CIpdSysPx8PFW3LlG/sL4Cja5uObaQRxX9i/t2u280Y52IiLFgIKckOhFSxZcsb3RaeAP2q8HY/bYXg6jp8DRLHrxyWwJZ8BnuKb7HNa9XLnRQu9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762532470; c=relaxed/simple;
	bh=baaBsMInhaoELZvoxzBFOESRxkB+Px6DvMfYihLI0UQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=grWggEd7lUeO0QjALpC5v3e413wL/2xKWdWDyKxuOtInxCgaYIBHShnytAtPkhRFGjSuX01kora4+RIoirj7WLVXAsHKClvgIPwFHGMCoXHpi1po2s0Si5Dd0BVxOQqxpah5yxQiN7Foq5O1cyUaXttTQMnNO40vJpo0as0UzDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hnuwduk4; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hnuwduk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762532469; x=1794068469;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=baaBsMInhaoELZvoxzBFOESRxkB+Px6DvMfYihLI0UQ=;
  b=Hnuwduk4HnAmT9B9v3UG83LTv4o/JnywRje5VUgCy0Nnw79qSTV4x/dp
   oCmdsGb4QUC8n4e/9r9miXKUWfUXuJCC7Q1N/WJpKYtncg9bd1I9WKrYM
   oRNK7EiQRKodmQ2+kZeuK1KG/ehRU1Ey5AjH98KSrjsMP0IwDQJUvg3AT
   awkptVhu7mMyg+d3uMoiWtxIN89GvSrvrc/WQ4Z1aGntJBjxWwOFrDnKC
   YikWHJG9RuGBOPhb2vwEaIn7kt9L4GvdPzJ34w5WjJV6f4J6EGYnZhcM6
   2JrLLY89rOA5M146t4Jh3SMNmEz+dVTrzkGdQIwybSYcV7ErfrTNJfD0m
   Q==;
X-CSE-ConnectionGUID: 52gnJkzWSdyu/PLq1fJYKg==
X-CSE-MsgGUID: npjYB53hSH2Nfs4Xu532hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="74978910"
X-IronPort-AV: E=Sophos;i="6.19,287,1754982000"; 
   d="scan'208";a="74978910"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 08:21:08 -0800
X-CSE-ConnectionGUID: e29sHiwvRYSyAI7FF+3jEw==
X-CSE-MsgGUID: UlSnY1ESSlCzeUdadW3b5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,287,1754982000"; 
   d="scan'208";a="188505207"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 08:21:07 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 08:21:07 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 7 Nov 2025 08:21:07 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.11) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 08:21:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8ivfapQ60Yt/K7DnkTYSt9oiXiGSYCR2Bx/omNcQLRUmHL/sgm8RfWkzRrwedCzr89eF13HLD9gR6iOqyJM8wNs7UIL1s9cHJ9rTAwWxBdMksSSrjtaV8UTQJYxZTxNoZztjxixcwvMiqQIj8eSVkzvMPFKvrY1kPgtarVp4XwqyaQNNH5tCSHOMqbqIpSU5beJduS6bipvRrAd3kM9lTLkGMwWnVYPtMM7dXZFad2VGX4YyU8/45fZ5nQv2M6zyQ3tHpHcLooiOobQYa6HGuM4ZHycvRfdhH44ctkhDmr0TsiFP9S6fU4D/Tj0tpSJ5zKt/xFqoYUnGnI9A9tZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1us3hBXaxl3gyJOP0Mwu+bByrbUt6p2iIT7zMwCbLo=;
 b=Hf0Q9bh7w+zd9QewkPjmbzWYAR6mxDhzoZOVkGUVCtY6TToVaAYX8AMKiDpxxlNMTfQZ6fHVZYT6K8LCs7VboJbmE3rih880nOhZ+Tf3oN5WCn2EHOGGqcxBqNsucP5KMVYl6HMRal01HeqVm7lU8CUQZcQj9POaDIByEi91s/YYuboBBN9nXsmBLHK9S8SdztSysjMqJrp9RxJVDF0E+eiKAVpl6CATs9TM3dj3HcckGnwC/XpSfII3gp5zWM3Jn2AjGT292BoNi1oqOig8EXBIRjz4+4eBbAQhk9ZWbHFnPQwp2FcXl1OTjvqU3XkNeuHKC+71seu66lMSaodlzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SA1PR11MB7085.namprd11.prod.outlook.com
 (2603:10b6:806:2ba::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 16:21:05 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9298.012; Fri, 7 Nov 2025
 16:21:04 +0000
Date: Fri, 7 Nov 2025 10:23:32 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <690e1d0428207_301e35100f6@iweiny-mobl.notmuch>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
 <690d4178c4d4_29fa161007f@iweiny-mobl.notmuch>
 <aQ2iJUZUDf5FLAW-@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQ2iJUZUDf5FLAW-@smile.fi.intel.com>
X-ClientProxiedBy: BY3PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::16) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SA1PR11MB7085:EE_
X-MS-Office365-Filtering-Correlation-Id: db6d2ace-98ab-4b91-2028-08de1e19a64b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NtBA5znqYxU5Ci3rNoDtM15JzsTd1iARjaWnSkfgpbsmdbcKcAH6I1Py397u?=
 =?us-ascii?Q?7Zy2bcvN+D668TMbCWlvirX/PZV64btwZ1wjHjlOzUfviU0LuAL8RjEDjRDX?=
 =?us-ascii?Q?kX2ibC8qcagbK1PepmfymSCdgPud6L23wy66WoTaOtTd+OQKZCWhIREUAaRM?=
 =?us-ascii?Q?1gFn3lHTV5oec3XPFkclziP0MXoxbZZvIqbMAvKFlfcIDfcc+W/v29vO6rUK?=
 =?us-ascii?Q?yiW76mX3u5V+O8lwTNK401OHKn65e5sEm8I2DaLsbuGuT5cmcs6EHKBRAjO4?=
 =?us-ascii?Q?ZYbmxEnZIZtEJA+b22cudza7xhQG4s6ZgOUr+kriTf++EI6eWxkWBBKJQoMn?=
 =?us-ascii?Q?ICstaNgo4rNC1+qmztef7nEjNlHp/AQbBDtP+Wo3bOfp7bngHoQffSZni1e8?=
 =?us-ascii?Q?xmP4Lk2r7iPpT71Sd/KQJbMUs3UsLFqO7rp3splelr5f/Bekppr3LfYuQRQg?=
 =?us-ascii?Q?xsKBLy0alW6kiaEHmNcl1nbXXE5lDmBjr/WALlTyDOYKYufWSPCZ+FWnQSqR?=
 =?us-ascii?Q?EjiUVgBlp6sMGLgEx7kUlFpA7ipxfAwf6xsf2cJta1H01ZOvT3f0JdubCfUW?=
 =?us-ascii?Q?WYNxNVbyOlM/Jfo4mmadK5Fa7LsP1ZOztEb2O6OwRlwJzb1CtuYi9Bn6meEE?=
 =?us-ascii?Q?CLewV9+drJ+grqYtakJsuNEiF0TnfsRcsgxC71zWpXoTEOQt7lN1gsbDUeSS?=
 =?us-ascii?Q?acJFsXsNpU9QJhBgoHVgGwlFKtDV367uFSaZK3+O1J//E+DWRgt7Groy1NKw?=
 =?us-ascii?Q?yf9YsQeJ7e8V0NGETrM6AteCxzDH+R9Rz0oBC6ITjVjK8xgNoz3v+pTalPmV?=
 =?us-ascii?Q?5MZ0VlpBMjYGVa0SvbqDWVURA0tY89A6vXFFOvXuXCAVfZBwS2JLBETeelWR?=
 =?us-ascii?Q?wyNk20tlk4d8LjLiErshXeRgTNbPTuBLxIBdM5X6G2k8HTKDY7rep67tZR+Y?=
 =?us-ascii?Q?3y8vDRxvkynYnluDqCpWCIfpaSFrJ0Zt/P/2PRvyVuC/BHkEpocZgWpw3GBv?=
 =?us-ascii?Q?gmhFgeSK/riuJuoFT3ZOGmGGqcsLlOPbwyc/l5N+dXz2qA2teE7xHllzDaN/?=
 =?us-ascii?Q?J75AgU7lPxTUMmQF9rdDA8d57xECuroxe9+xRvCEe3sDxkiM+9eoG/si3zAP?=
 =?us-ascii?Q?CtE2YBd/s9OIYXqXBBHE1z1qq2nCLCAM/T/yJyKsMUlKYM+tdR9GGd0Npzfm?=
 =?us-ascii?Q?6k9DUFxZfG5RJ/7bawHx9I+ULzDGChqjgagkEiNGatQNR4il7GWaC4iSzRyS?=
 =?us-ascii?Q?CujDoGf65nzEC1cyc7/ljj+pEa6FoE2iLeQBBHRrXL2918utzFahBt6WcdGu?=
 =?us-ascii?Q?Zwm4KaQZwZ+bvL2pFlR4/V+qCcdCzfzYEc0s22oFbylSbg7kjandMjh+qKYZ?=
 =?us-ascii?Q?P8oR7GZVIbH2l11QgyCcVQCsfZEAQ45Jm4dfNsj21QbKqyw1OGm9vHAJEhil?=
 =?us-ascii?Q?db03c4kA51LcUfFYUJAytjhfkjumlv0t?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IHcihRYBJjUJ0jUwKAqan7yGuBSpthBBiBl8zgPVTBEtyYZQ8dFzmnnpLLhl?=
 =?us-ascii?Q?GPu1kruLhrriU5oM01rD+4Bsjw7n/AfRSGHIDjgADf1iefGb3JAcYl2PQ2Cd?=
 =?us-ascii?Q?p3Bv3Z9Jh6I/uJGOvAPKmw+9WT7R6bSdP+++eqKz5bRv1KEn6X8S30+vgonm?=
 =?us-ascii?Q?MujCJt7MIecDbQQ+5UD74FEkeaVpXEBaZYwfn6sGfbVJuxPUMGV8h7GKi306?=
 =?us-ascii?Q?ICl1EhvNnrig1C6KdEe10RVyeZcF3HE4fmpUDiopgkuZOI5oMwXL6EqagUU6?=
 =?us-ascii?Q?T5K+0diZqcYvPzgKU6i/JTGSOfQTLfKw2/gWfTrxtvV0b/osqqdOsdGqq2/X?=
 =?us-ascii?Q?fNFOCVVCRqXTduREmVXRYkHuR80GpBmkbdkt6JtmQM0Oe9HNgv1TPOkWJnVP?=
 =?us-ascii?Q?l7350G5zDnIXFAKwtdTv5BhrWz7a9gygL7OE78p79O6+HqGVd3hFYRbOX1mF?=
 =?us-ascii?Q?DXzEB71AOA9RibDLaTXGkKFCrEU7l8hLARaTBjIOfvyLbUZfmv9BpRKc18YT?=
 =?us-ascii?Q?OGbs2nTxgoodGGNYLIP5dwcSTEvz0EOd7cqk1GP12I1YWyyVPEmKEfVBSsp0?=
 =?us-ascii?Q?KGchDHT0rrq82DWkRKcfALQ3dHL+YVsOXHN9i26+nHW7wZ9QaXqTwMtceNxb?=
 =?us-ascii?Q?gmrz2vdxuSmThgghaRXNfZmzTtWzIkh8XzN/vuNdgAwmt/MnnUYc/2kcLTgv?=
 =?us-ascii?Q?1pRYulsSRLPNbcG4TVrM+CbikCJ3CSdr7tPqwglYyRIPnwZch7GuH0TtEaTa?=
 =?us-ascii?Q?UTDf7XkS6jWZ/5rG/ALrnq1Ln1jsZxBur/xQe0i8n/VpwWAw7wMGogYbkGRA?=
 =?us-ascii?Q?3gXfmnw8CNlrnWGe+EATRt6rvnk3zd9Zya2EKyS5RLgFObyCkhZFuS9C4WVD?=
 =?us-ascii?Q?RuNm4AoXmeifDxwB8bKkocgrOV2PYn+UtZ4sLWmDsgGr6Vvcc/tvZxehOeju?=
 =?us-ascii?Q?0zL67zIL/UgL2RrM14WluobfJ7kc+YdANNsl2D0mPhR6BqYPkp/rzHh3IhAm?=
 =?us-ascii?Q?aWKex3krHGSBpGhyPPpJyw//83mfM3apcMLzES+nWB0PPYwiX8rX/Vt40II5?=
 =?us-ascii?Q?GByAxaFKYtl83y4VcxdMUfkrbFIhrakDKhg+uedCTLTpvwRbiZUJJ2Ocm51u?=
 =?us-ascii?Q?vBlFY2ybUIS98rdj4ABmOqXsTN3kTOhb4uB29ymC7ua4Y1o0l+664EEqiXhE?=
 =?us-ascii?Q?SGdR6fKxDmiGftqVg7QbMjfK8Y631zixEyKQsZTmd7Y+nWKBt+MEz1qlbjby?=
 =?us-ascii?Q?wy/4xTpFmQ190s2lnFdR8vrLp+61XN/zoktQFqQjjUo03Mx+apGhM/a6coKF?=
 =?us-ascii?Q?6ap/Us2xLi431MyNxO6SIp5HLDeECcMH8PCaXJoQWAwGUprEBWD+3klcgIvZ?=
 =?us-ascii?Q?BcN2ostezHn0ObX6BAD/60EdyLG0zCSZCTQElz8fW1yj3rUmfCYKc4IEOQVG?=
 =?us-ascii?Q?iI4LD5dKAdL8KDZ4vVVpjtn90aPGgT5Yq3qEnZF1OaDPkqrX/kjFYTIbpRzL?=
 =?us-ascii?Q?qd9jbgeVdyzc9dQsmQiqtWZv+Ma/fz4culT5rCehbuuk6GTXnP7PuAoX0Sqp?=
 =?us-ascii?Q?jixnE7IZeJRoHySttCclkjWYgFT/RzKt4TMQVOY2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db6d2ace-98ab-4b91-2028-08de1e19a64b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:21:04.8746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yy0QGSMkEoFTrS8Q3cFQ9szq3YtYLKwUeNhAzn4heWcOu+SkY5nn/S3++SPpoXym6REXFpWBOaoQIuI67x+Oqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7085
X-OriginatorOrg: intel.com

Andy Shevchenko wrote:
> On Thu, Nov 06, 2025 at 06:46:48PM -0600, Ira Weiny wrote:
> > Andy Shevchenko wrote:

[snip]

> > > -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> > > -		/*
> > > -		 * If we're modifying a namespace for which we don't
> > > -		 * know the claim_class, don't touch the existing guid.
> > > -		 */
> > > -		return target;
> > > -	} else
> > > +	if (claim_class == NVDIMM_CCLASS_NONE)
> > >  		return &guid_null;
> > > +
> > > +	/*
> > > +	 * If we're modifying a namespace for which we don't
> > > +	 * know the claim_class, don't touch the existing guid.
> > > +	 */
> > > +	return target;
> > 
> > This is not an equivalent change.
> 
> It's (okau. almost. later on that). The parameter to the function is enum and
> the listed values of the enum is all there.

True.

> The problematic part can be if
> somebody supplies an arbitrary value here. Yes, in such a case it will change
> behaviour and I think it is correct in my case as UNKNOWN is unknown, and NONE
> is actually well known UUID.

Yea putting this in the commit message but more importantly knowing you
looked through the logic of how claim class is used is what I'm looking
for.

Thanks,
Ira

[snip]
