Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98E8264A96
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 22:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747951541; cv=fail; b=m+FIMGOsSXOB9RnGiukM3aFLa+BQnQHP8XvkQDDAZM9atqUFPWS4cYMjerpCUHD8lM4VfrOPyXUzfEBv+HpjSP1rs2s0T5a4/Uiy9mAc4xshoIdwzEMpT7Iaq1VazPdoCoj/g2w5dyVxiu430gj/ZRGDL3CzJjzwGvBHWNkI77g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747951541; c=relaxed/simple;
	bh=8iGjjGubqlz3c0pnwVq2PsWgQpZedUeZNdCtghviKbE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rrJyoc2Ju04vJRhBwuGkVQZRzBTllgtnUDz0bo5cHibCy0W/mwwPqNXQwbkQt12mK23SlxQkW6KE6yTqWbqElhfPGkrpo/1Z5yEdiyNgmWdsn9mDMdXpy3zjMaU3eadq9FgLFrDC2jKw62JeWHYRqfLEgUjwJM1zkLBamLZicJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UQgFc4yV; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UQgFc4yV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747951540; x=1779487540;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8iGjjGubqlz3c0pnwVq2PsWgQpZedUeZNdCtghviKbE=;
  b=UQgFc4yVvjjGCnJz9+GNzWVvkc8ygipWUMudB5k6VYlSF95ecttXyHO9
   wfaO8pX6vhKjNShHMdR+GsAB3otoX4JG62ky8mTFy+ps6BJ1VYkg0pyxr
   k2/i/768QCekgoIQQYlMwwMny1WnTvMAxjzc1cDAwi4F57OIscyqJfImt
   DMKtZ1WEJ1s0xshu+dGXBJlTHjeLYADU6zdWuUfJ5x8xESZJpuw/7NfhT
   0zRgdUREL2lbH+0cUmN4nSElt0wWjvOlS2polle/BJxwxUoNQcMi59izH
   TazAZLF75/+1tr58H9YnjiRL1/2MA08RdL6in//4C7ceEPkCpWxI43HpR
   A==;
X-CSE-ConnectionGUID: t5da6d6mSq6cveo3CBMCVA==
X-CSE-MsgGUID: DVTwNsB0Rn+YM+JjDrtr3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="72526979"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="72526979"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 15:05:39 -0700
X-CSE-ConnectionGUID: /j/urqQeSnyAcLuv5fZZYA==
X-CSE-MsgGUID: bv2yuEGoQja89wRrNO0dvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="171680805"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 15:05:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 15:05:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 15:05:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.87) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 15:05:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U58ZwVVefE7A6XtJE4ffFYHs1OnIaQSfrr7tZTGhZK2dPpTRjtD9PC/YwfsdZucyQ35alcL9+z0JUEIYrU+cx8crSqOroT+DZOv26jwMPcutOQE2/zYHwSyAcLDYVjL8RuV1XkaINrVRYht5hf4Ms7UkGUdVqLqQyxN8gMk41aMmVyd3fd6LxZfoecbakN5ay+gnQlj9FYLmfa989aJWk/q7nlRRMeYn0tv2RGPna59kaSq7vEOloyL6Xb2SibsE2wjzEI+L56rxts4VoCkLWgxX/d4G5SB1AwdFFRngfTeYtFnOeD4VxaeLMR9FCDul47xdyMtdix5cm9t43P5+HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3ppXGjX0ncOQKFe19ebc93uksJoOwqe/Z8qWZ2OkpM=;
 b=sKRjGE6bGD917SJC5zCmKmaYtLcN9iiv25uEanutDEyyAQHsE0gTb0YxHL/hF92q6yAd8dJso+Hh4PsLqjMHHNgVTl36ZDya8tPvXmNBqSRoFJv8OVq6/C9TMpUPt0Tus5Xnng99IWvk16ZaN+AB7QJTMo81ziAY/VN/nVs/tWEYHrtXzmWei4ABWH4MEsJR3ho5OSSvlxFQtJGxPvoCp/pIYyPSe7c4OnOJhI75TIKsAQGwNTfmx6yG2gQzh9mQbcfEy4PAOLI2kAW7ArWjLSc0SUAZH0B5pD4TJNih3cqjOcVzXR/Te3Zi/uXsr6ezDMBqHubFFNjqdL5HDb4Dhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SA1PR11MB6711.namprd11.prod.outlook.com (2603:10b6:806:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Thu, 22 May
 2025 22:05:33 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8769.021; Thu, 22 May 2025
 22:05:32 +0000
Date: Thu, 22 May 2025 15:05:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, Marc Herbert <marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Message-ID: <aC-fqTC2OWHKQs1v@aschofie-mobl2.lan>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
 <f5174c3c-81c4-4e6b-8d3d-7fec1624e964@fujitsu.com>
 <aC6pdLThSU_uudf8@aschofie-mobl2.lan>
 <682f6f2aab38b_1626e100c2@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <682f6f2aab38b_1626e100c2@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: BY3PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:a03:255::18) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SA1PR11MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 27922406-e1f3-41e5-7d56-08dd997cc577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TD63oD0W0L1JxViy5aWmT6boOxi/RTRwLMbGZxN5oLVyPpMXsssfWlh2KM9R?=
 =?us-ascii?Q?QwNTuJ5QWqsUH6ckuUwMjFJAqkgbugBHyrU46SubzAYQyKlAQ7nAnCf5pTeA?=
 =?us-ascii?Q?TCFLwKkKLKrZD8ZclEhxs2h53xM8J/c3SaqUXWFro/47xQoIuDxhtRnhkG74?=
 =?us-ascii?Q?gojui7Qd9wnG8O0PANELLmB0Lzo5/wYb8GZeV3KcAHLhn/nqriF0/wH+LtlR?=
 =?us-ascii?Q?Zcl7uSoHgFim674onh4/VkSSZND2cTdswxHce/81yiWZtxtFT6m2byQKPfre?=
 =?us-ascii?Q?LClMnJ8ivCeki1apdOkk7/UYHGHWDBW0E0SbI+ZuXWdVm/UzfLLxfyGSOIzS?=
 =?us-ascii?Q?j77utlQol3SKwzckSQ7BRVGHYUmKxRTYpc/g9dhrazAP8BWZ7cg4wrXoz0QJ?=
 =?us-ascii?Q?q4spVWaEqOPltLq38HlG/cjddv92CpybO2S5RyzR2Csp9J038qdP0NrDZJQ+?=
 =?us-ascii?Q?oc3w11HZziCPXoeBaodY2r1tfDPhiapdFH+HFDrgEjea8PY+Lscy3AujOas1?=
 =?us-ascii?Q?j17NdTQ7veN2tvGj40j3xDBAE6ftQpnlpZobHDNxT2Nwdjox7yuP0QD28/AN?=
 =?us-ascii?Q?oT5MWN/lCHd9OrtRuMep7oACA699vBNnczDEN3NYmYERjU+IEAsGTKB8TXhG?=
 =?us-ascii?Q?2IOgorbxrO/fszWir0ok9B9il2O6ycs7KEWiX5wpOmdGnsYJ7OKtTH8HVlSd?=
 =?us-ascii?Q?RlYSEezU/gLAre2SGGLWd5CFMBYLj877LX3FuSxRBPahb+D1yhdmYxUBkeRC?=
 =?us-ascii?Q?EPUMr/Xd3bETdF/A9vm98MZlsz5BeFK8ZaIyjSLoxL4AmtiPjqUj00VVvECx?=
 =?us-ascii?Q?aiCEAmhEU8pR0zEH86s83q8uRXMQzbby06foo/6Qh+n4wNVPn5tGdGoO2Gyp?=
 =?us-ascii?Q?nY8kB2JFu6tua69x5LIcsn/IWJ3NMoWN59gTcurNR+xaZQHmTXUfigo9ZOrG?=
 =?us-ascii?Q?UUKc9fd9/kjcPA60HrL0WJlv7HIn+P2jBZZ9P/tCZ01uH68lyxFWVsb8Mrei?=
 =?us-ascii?Q?52/aaNGEZ01cxhvhK8GZtEvJh/iA0d3jxx59oet7ry7dSkVjaN8wmkxnaT5G?=
 =?us-ascii?Q?EU8tUtud+YMMrBAnFpdFGPmaYAZWyFmDH4RXDxWAGCMgbyof3DtQ1Iz7lHTO?=
 =?us-ascii?Q?6mcASr9aQ6PO9vw7wSNwgAd32rVOkHrnRGKhlTUHS1lKkHal3rrcxY6U3VwY?=
 =?us-ascii?Q?SizAXZOz9KcK8kqhubXwAeoZnDbXuZ0hig8MZ5n0wmn1Pwl0Tccto8HY8toD?=
 =?us-ascii?Q?PYfPA1+7MJ5IOeJaAg5ZSVM/fZuTLt2aGiLq01AghtgHsdA1uqSJRMZ+uUb5?=
 =?us-ascii?Q?G7BbTQwEoM+VG2A48HliuEaI6ajPMl2W6sqZYz5zlKxAyTKTS7XX388mEyD9?=
 =?us-ascii?Q?Bp8djhM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l2THTEAbAit/odL5b8/xAtpH7BTpNWzBUfUGKJPBFsT/LDdPEMYN+tlLyrM0?=
 =?us-ascii?Q?iHoQlD3RL7mddugIeEoS0j11kZAwQXrjlE7+vHpGc6YCvYJUAbZ7DcHNXfiN?=
 =?us-ascii?Q?t4vC2mxtx3WLAMAbapKty1qhfBsA6hkqWReHKMm6uzY4UV2fwyL/7xn7nf74?=
 =?us-ascii?Q?IUbHaDkka5rCcAH0fEfsvd4EDWFN4e79MiV/kLYABkc21j/0lcaoTTEBNpa+?=
 =?us-ascii?Q?AX7CPhRrzbXhHZZG5TiSXpMf/L6efNzHTSYIMTjqJUix3wyA0MS+bMu0Z8kW?=
 =?us-ascii?Q?RDmbkQkIHF3tc3q0IN5You4zmgMOXTjiV4CkZghyEsmVfoDNHCjuX2iQLKa4?=
 =?us-ascii?Q?9TnYGViRgNEzikl3TTUO5b/DL10AWoWBHINqpBgNk5FXFmQJCe3R8d7ZdZXv?=
 =?us-ascii?Q?IIgT/H8LK0pyorU8hVi7qevpCoxwtuPKjOgwberh+1LvjRH/ZRA0Zbcf4YnS?=
 =?us-ascii?Q?lVvdRN2QxPilSypboHWKzV3XjLchdC3PNOath0sPC7/JR1r/06oLfa9t4Ys0?=
 =?us-ascii?Q?hpGJqT1CyBoTS6bWEgPKJ8k++TCSY3k92TrrzGVF3N8IJiGWaZlTSwH+J/OH?=
 =?us-ascii?Q?TeRDi5zQqnBxMpFAJo7dGgqhrZqFR6l0fMXOrU70+fHF0XzP7hzyHF/nEAAd?=
 =?us-ascii?Q?TPlHkNdMDDPWo133zcWmY918h1g6bEIsBZXHT1DKSyAXky1C7xbyZPRsv44K?=
 =?us-ascii?Q?PniZbyitnuqP5caWEFhgxoZv2nnIFv58rLJS/MsO+jBxGcZyuhgfYJnsSL0P?=
 =?us-ascii?Q?qEQ1kH4+87SJKYPahh+yWAit5KMBzEEyfdAEGqD+KddxQfDGbQx8IuzY4bj3?=
 =?us-ascii?Q?vD/fITFxnxExTzad3E82MAbm/NwP8Nedq9FPHkANbrw+f6v3ay9xxl0wXMvh?=
 =?us-ascii?Q?nvY/B84yBV4SSE4u32uMF88SAtjr0m3Y+jadGlahYgb43MEaAzCgTWOjrlzD?=
 =?us-ascii?Q?KPzT2U10GxbzyCloe5U2oYMiyqlAQq8Hh3kh1/lNxSPgHJKyBhYy55rEpSxD?=
 =?us-ascii?Q?y3spDAQqMqZtf1XvsbmTiJ6f7/4B2Sv7v921vDjMwemZAhBkIjPL8AHGDPcI?=
 =?us-ascii?Q?AGoBwRTci3Ng/FFMBal/cH3MmR/jSZO5MKpmkOBvcI2r+GlFu7j1QP1Bdiyg?=
 =?us-ascii?Q?Y07rrL6FUP2zDKjGzQ8aorz9aBiTzG+gTLoMGYuukxu0+2mb4e4Qi0wLE0/t?=
 =?us-ascii?Q?OIJkQWHUgc7IY3Yd/2sVU4OMXcwo7dSmxTBie2jhDZ5+C6A4CSdg0wJ8rPIi?=
 =?us-ascii?Q?OXSZCM6NaWe1b7ht9BFaMpySCkciwgF+EzylYUU5cZQ4gcifVPm9S614hue3?=
 =?us-ascii?Q?/C8mhV4gpt6XWIbH2BHC2wvZMT9ceJuv+ngSNdRvD9ntm2J25UAOZJFtInXl?=
 =?us-ascii?Q?dgqebqy2SgZPerToyvn3ZHA15UpK9BACM9v/osiP3RY0Ux4/IUhsPvqlA3da?=
 =?us-ascii?Q?y6Bh1yrf6TCSOnGwYelG7F4BjRZmnNYRsXBwR6iYhGdzJyHLooji7G+OozrQ?=
 =?us-ascii?Q?1cVNxpSQ2Jl/b1EIMZzwKi6L929S/6i+DjNhJpos5reASxWqj7vmhbJaY06y?=
 =?us-ascii?Q?L7OYXm78i3zKikuIV9S4/GU86r+TdLFN9djfRsRMmE9OwObSf6hwUdFYWQ97?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27922406-e1f3-41e5-7d56-08dd997cc577
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 22:05:32.6840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1c7ExfBggydsr0KgQKe6dk587/ZmM8nR3JdyncP/kwcFKw6BR4HBm0P8Xu2tvzgxY+JDN5X4oUdVhZ5s/L1N4WsJScIImJZAkjnt0uL0HiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6711
X-OriginatorOrg: intel.com

On Thu, May 22, 2025 at 11:38:34AM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > On Wed, May 21, 2025 at 09:00:19AM +0000, Zhijian Li (Fujitsu) wrote:
> > > 
> > > 
> > > On 20/05/2025 03:28, alison.schofield@intel.com wrote:
> > > > diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> > > > index bd8a74863476..925b37f4184b 100644
> > > > --- a/ndctl/monitor.c
> > > > +++ b/ndctl/monitor.c
> > > > @@ -658,7 +658,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
> > > >   			rc = -ENXIO;
> > > >   		goto out;
> > > >   	}
> > > > -
> > > > +	info(&monitor, "monitor ready\n");
> > > 
> > > 
> > > This brings to mind my initial contribution to ndctl, where it commented that monitor expects to
> > > output content in json format[1]? So this update could break it, does it matter now?
> > > 
> > > [1] https://lore.kernel.org/linux-cxl/4c2341c8a4e579e9643b7daa3eb412b0ac0da98a.camel@intel.com/
> > 
> > That is odd because right above where you wanted to add that info[] to 
> > cxl/monitor.c another info[] was added to the log for the daemon starting ?
> > 
> > ndctl/monitor.c has a few info[] going to the log.
> > 
> > In the ndctl/monitor.c the presence of a log does not mean the monitor
> > started. I'll poke around more about the need for json. I get that in
> > theory, but I'm doubtful in practice that a json parser would die on
> > those info entries. 
> 
> It's not just monitor, the expectation for all binaries in the project
> is that all stdout is json and anything that is not json is only allowed
> on stderr. That way you can always use these utilities in tooling
> pipelines that do not need not to build a pile of grep and awk to
> extract useful data.
> 
> It turns out, unfortunately, that LOG_INFO is the only log level in
> util/log.c that violates the expectation that all non-json goes to
> stderr. So I would support a change like this to remove that trap:
> 

Ah, understood (now). Thanks & will do.

> diff --git a/util/log.c b/util/log.c
> index d4eef0a1fc5c..4ee85c7609c3 100644
> --- a/util/log.c
> +++ b/util/log.c
> @@ -18,10 +18,7 @@ void log_syslog(struct log_ctx *ctx, int priority, const char *file, int line,
>  void log_standard(struct log_ctx *ctx, int priority, const char *file, int line,
>                   const char *fn, const char *format, va_list args)
>  {
> -       if (priority == 6)
> -               vfprintf(stdout, format, args);
> -       else
> -               vfprintf(stderr, format, args);
> +       vfprintf(stderr, format, args);
>  }
>  
>  void log_file(struct log_ctx *ctx, int priority, const char *file, int line,
