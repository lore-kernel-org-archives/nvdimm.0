Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D6421C194
	for <nvdimm@lists.linux.dev>; Fri, 29 Aug 2025 20:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756499585; cv=fail; b=kCvPd0eZ7g4gcX8GeDob0QzhjUarAM3AbKzhACwpAG+tL9LcblgT6VK35J/ZmshGemHbARaaUZn7pcNw5PNChjgNKV9ztEwnemvtzTLmnNaMyj7V4KCWafgaIORamZHU9M9tQlvRiGWb8oMuQKwMRGkmx8N1dhD4pFnHxhFcgLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756499585; c=relaxed/simple;
	bh=GaItT+dZ4VPCgWLs6+JxG2I6dbJ5/83sWXPRTETIucc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HEnK+8ZtC1nKIjsABgJiXmGjgK4tNBSTsfycFIPvpUhV/y9OeG9HzL9QMKZI+6jA8OgLsNetTRbngnx+RxzA4EK//Z6c5lN+QE2097KlekNBRlWpJ2RgRV5MMTKFKm7WmIjU2/nfOChzmdSzBKYZveftzLe8Y0sJ/6WSIUEcsxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fHDPn/Qr; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fHDPn/Qr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756499583; x=1788035583;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GaItT+dZ4VPCgWLs6+JxG2I6dbJ5/83sWXPRTETIucc=;
  b=fHDPn/QrAN+fdCMxhINB1Wy/xzoUjOhKRk4iY8AvLv7t1GXXoLqMjEH0
   noYWMp++xrogTfUPiPq3MK9/6iTFvuw+IlBKwfNdJ+Y4B/W6xs6Xf2AXH
   QW2U1NkxgzRjC/wjwtsNAK4+L30BDbY69DO7MztWPqqD15m5/UIkG4M+I
   OUFaXDyRT+8/oJ1g6WIjXj4AN4CNNKSdz1YYzX3CQDvYe38d65ig9q+xc
   ovsnynpayERFTxVasM96NlgSsgz1aa50BzQqlTJxDGQJqjhWkoOacEl89
   8ZkoUri3m91lEbH8t18NfNyu9ySgZJh09G2bQepKnpwfFS2exEdprEPay
   A==;
X-CSE-ConnectionGUID: sL+D6ODURUiW0cH+C43ZUA==
X-CSE-MsgGUID: ajlrPFPJSFSmQx2DTGMH8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="70164074"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70164074"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 13:33:03 -0700
X-CSE-ConnectionGUID: H5Db5aJ2QdaslnGAex/qBQ==
X-CSE-MsgGUID: Bz6neoKvSrqhN+BmQgOCPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170852937"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 13:33:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 13:33:02 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 13:33:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.57) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 13:33:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JgZM45HV7nogLqMilYJljMloNf8JlhfN2GdMLk9MPFyBOPB6AarPExn3QdmWqIHJiqaFyAaeA8dMZk7CeAANdxwMSneZHyVt5EgdqeK+NKdRun3p7A7MS3hYtwO6DhvayZrbmky3TC377pRpcaCo+exZPFRn56x6Lm/HtoywDaedQKFMbb0//eaHZAaDJz0aaP4EAiU/Sj2wEWFMtA4V5JnYxVBBSVI/jY1yU1tEykbDqerlDTrstV3T6j5+kFHgHso0oD4VFd7vnBQdRoIgIaRZO1Y5Km3BbkK8OBL9YkbGy1xfeeQEKWxDkX4jPKDmwDV6A0f+vVCurVj3LkwubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/KU9IEaNvPaYR8UFs/mjk4QdHrlNJoNxJHuNWVPWFU=;
 b=Ce+Sc1A4YyQhhttYEj+G/BTV+6YfqFKPhk8a8RokpUGFygCWEh1gZHuSQGR8eRENE37nxVc/3vSDigMDTM14o8qJL2u3zfGTQli1utOwMGCWkBUyvnDgaPMHsWbzNjKbn/F0uWJOvpNzf9S3/kCCmMUAVfJo88l/PNDXE8y6jgst3LIzUm9B+xRxYeLhEUAbxkkj3p451DK/NC8qpoggIwJn5644k3rhwMybDO4Sli3FLAQXCu4dZy1THU0a4NP6eH/Hxd8xDLPuKVfuhNlehHMdkCHu6qT6COrfb9BI50fO3m3Bt2n+bRwrIkflw8hdcGy3VP12SwSMI0nTWH1rdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB8452.namprd11.prod.outlook.com (2603:10b6:a03:574::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Fri, 29 Aug
 2025 20:32:56 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::5a0a:3196:957e:6695%7]) with mapi id 15.20.9052.023; Fri, 29 Aug 2025
 20:32:56 +0000
Date: Fri, 29 Aug 2025 13:32:52 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Marc Herbert <marc.herbert@linux.intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] cxl: Add cxl-translate.sh unit test
Message-ID: <aLIOdBgZG884Vy8H@aschofie-mobl2.lan>
References: <20250804090137.2593137-1-alison.schofield@intel.com>
 <176191f6-3cf6-4d96-819d-28146f4646d1@linux.intel.com>
 <aJ1gidnZblX8EQTK@aschofie-mobl2.lan>
 <b64b9227-2406-440a-8cd8-95519f987b0e@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b64b9227-2406-440a-8cd8-95519f987b0e@linux.intel.com>
X-ClientProxiedBy: SJ0PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::12) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: bf2364a1-a4c1-45b5-7a61-08dde73b3c50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RTvzz3vLYK+iOXkSvVYfmEAITt1uykFsiEMY6T2XASHRbqjZDM2emaVtjzb8?=
 =?us-ascii?Q?lcBJoCQxmqdG/GFEcMaPRCadZfgvqfUMwnnTpCIzhXjcNjVzpp33ptXObRHZ?=
 =?us-ascii?Q?su9tFZETeLfJhqYp9GRphRwo5uamxdioREuQ5QA0+Hurue5zT/6OCefHBptS?=
 =?us-ascii?Q?7mkjyNzrsK7vfRoSR1E5yRHGwHyJgLFNG5qU2UhfIl5NSwD6Lv2U6skQOMB6?=
 =?us-ascii?Q?dvBM/05YebUqWCU79l9gS6RlS67fvt9aRDuP1mLnYACzAT1PRpENRj2ms6MB?=
 =?us-ascii?Q?dMYBF8PhkQpAWZS+eAP0fA6W1HCW091ou5xaTIT6l4a2wK89UNwN64Cp6WQT?=
 =?us-ascii?Q?OiaybokWuNh2sSH6f7YtEc7xtIbTR1Te5Q50s0Ljq+yPSq3FKWRcDzt3boTz?=
 =?us-ascii?Q?2/0aityH27Wu+dJVes08E2JFaB+Lq9UmSVnMkR+Or3VmZvd6CaYFdEuiqlJs?=
 =?us-ascii?Q?jUDBWcdloiPA4b3xoN0lFXwItoiYXoHAnOhHzFcda8vmvPG5CjXaqgafzJOO?=
 =?us-ascii?Q?8e3CnB8LTDOpdRV2OeQM6jtDJtSl2VqdfVfUmdzlbYCQ7U0k+tTlgbMboGB0?=
 =?us-ascii?Q?avLCAYChtBHceYiam/t9yvVoqgvlQ2SMhk1w8oQm3R0JUcjhNH3cKX/J6KtV?=
 =?us-ascii?Q?o2rzZXvz4KWJN2PeD4qDDZCbjbq7ohrNEk3JuaedyZn9eKNNsStrBO5ZKJfm?=
 =?us-ascii?Q?lgymYHCXNci64lyOFOjlva1QorYz9K1MY+FRDoe985GTAUlQHGILwqf31R5v?=
 =?us-ascii?Q?w09XDXOGuPK38x2NvLsRpKk16e3tyR0LDU33O0DQlhJvp39lkdL3l15vIrWz?=
 =?us-ascii?Q?8NZ9XK6QLNJVGbLb+z9pSQCTjQmjYi6FsLTJ54jgnREyxrBL6yfnuTy4h98I?=
 =?us-ascii?Q?30dBlmAM3y11GmWpAk72HaF0QNYzoqVv0x0SuMl40SbEncMzG4l+N60ZI2Hs?=
 =?us-ascii?Q?jZQ/++on+JOq8ZBfSWh82OTI3Q3yqLR/7KOdpKyRnuVd+ZaQLa9sBcg1DWfn?=
 =?us-ascii?Q?5DcnEZb0V8rM0keAAdJK7Gdiz9aCTQeUsWn1p+fx+C81HgYFW2drBerETyIE?=
 =?us-ascii?Q?JFAdaUNZelmLIT01/DgqECafeZdXjV9roMtMYIaZZd0clEA15p1MqteOQpQp?=
 =?us-ascii?Q?fXtiKbM5yI4Axx/wQH9nVmFt6OA7LlFk49JjMM/XnqiYfrRopLs32sfhE/ri?=
 =?us-ascii?Q?WCF83k04ivvML/3wqNSFaW/QJWwv3Zv9j/ufgw2OjXHFPON+KaI9rr+bNQH/?=
 =?us-ascii?Q?vmlxYi3dCRNjDawBOe5R+93qGZMGwJC0aF8Ys+Wtj8ZRVBvNVb+LdHP/ljXC?=
 =?us-ascii?Q?eFNutcfFDdBCunxQeu6n8fyUdUauzlJN3sGFkxwnbsodZ3FFK9CP+8XeqcY+?=
 =?us-ascii?Q?+/l/YObxN7gHTXA2WyA0y0H4cpgngYpb0eoVreVMzq5PLWanb645dlIvEMyZ?=
 =?us-ascii?Q?szAZHAEvpv4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?raSB+a54UbPRDJesuD+wANkn5l9xFfeN3EvdE0UnCEOs/zeSUa60S//X64Kn?=
 =?us-ascii?Q?DUWRkAiA8XVEBbbCXuIg6ANPofZ75bfLPl4f0PQs/qyph2Ba2Xsc9Rt8AjNi?=
 =?us-ascii?Q?v+4mdWek5TnNieCjN/6uF3YcnGl/FPAJE+UWwf+r+RY4FQYyflZ8xcdJYOZm?=
 =?us-ascii?Q?StB0mqfLK5t1U+DRv4lKST2EHqExZQPPModWjYJJgEglj8YjSPrMidDAzhq6?=
 =?us-ascii?Q?x+1cKIzEx7rSRXT7eC8SmITmFzMruxYYl/wvtsHZpTgpSakc9zTA5AcR66js?=
 =?us-ascii?Q?T8SmMUPUv6VJjEQesZY4VIkxcOwSuzph42UkFtl+D7YwGIU+lYHfpwkEdnWt?=
 =?us-ascii?Q?ucsTS4hv6bOFYAvXljU2386ZkK5k9TW/q1l7RR4bPh4Dln2/LS0ydsVNX/Zn?=
 =?us-ascii?Q?ns38ZLEllir97eSQ2BGO7WbA8/omtWurcdjY0vo7LRT/Y93HaN+7OsGofEn4?=
 =?us-ascii?Q?vEvRbXOwGMQf7sD138f6lSZ8UwjXWoQRcRiegKukrWP5vlQ3HdFSWetAPg7B?=
 =?us-ascii?Q?lyidR75MbO44KSFgDaYIkkh/XwnbfGHshi0dgSc5stI/fnLKUH2ymn8YpIXV?=
 =?us-ascii?Q?e/1o2yAmTjvbYjxIEW7UVDvArqeEk9krdDtXVYrTXrkdUQEEMtUkeNpmzfFx?=
 =?us-ascii?Q?o8at0QcEm2Lt/+FxuBDpk1nHrhldNkpouvJksuLjX7vPHPJbHloK7DNafS0I?=
 =?us-ascii?Q?7k1QL0j5r4XezcAmEc0Nu/Ku1H+nJpb2gxQClLKZRz/BhXPA9fdg3wqi1sOS?=
 =?us-ascii?Q?2+C7z+E4Fo+VixiwHE25kE/uoXowAYuPVlFm8tEDB1xtNvqM1xmrk46frDT3?=
 =?us-ascii?Q?HWQ4W4Wgr/a6WaianSQk+kciI7j+dbmUbVWN+7jH7w2l8OvCXxXv0sq0C5M8?=
 =?us-ascii?Q?WzWzkIhHyF879iRlrL6qzdzl4BSF40OmCbbltd5zwTbUElk+5dE5tlRFBnWE?=
 =?us-ascii?Q?Pvr0X7gChu6vkd5T2Q/dY+C2BQFsizswfTb/Mq2kZApld5FhIay46Zl2ZM5D?=
 =?us-ascii?Q?LIueqPubLuZ1heJNGWSylINjlO82FSI61NBIBSYd5hNduggDOThNR2JRGrB2?=
 =?us-ascii?Q?y29agQ6hkhsdEs4UGTKiVBRRTAX6mXxK/NdS96+J/ecR+kKiQnHt/7H89XED?=
 =?us-ascii?Q?2d/TfegFRdz9/aUIzNziHiJR/cy7l16wJBtIPlro8tTby/yjh9HcsT7amMJn?=
 =?us-ascii?Q?F4fVq38uOWOtyesqa0YWqApuK0lb5KEm9UGbDtBm5tyYKt0ztuCylAPTSAOW?=
 =?us-ascii?Q?ibAQxxrsaMrzXQK9oRWGmC5ueepgl3FQAPK4Sh102qwXHnCAcg0giig2xwEQ?=
 =?us-ascii?Q?RBlimTVhfwyqPrZgU4oV2fceD/9f5MT3OGgeb3YrF2PMKOLkjbtCBT0yNr8t?=
 =?us-ascii?Q?b7ZIqdoq2h/mHSjPlnUNCfrplkuAoz23Dt1oto7hk4Ev2eMJpOGvz/M3Uira?=
 =?us-ascii?Q?je8P5MQxfymnSoGEwUoILqa437voSgAo+oOTTi8t4bw9i8KCuLNGlKi61N9U?=
 =?us-ascii?Q?CvW5HHWANwHqVNrKZU3UnTZQFAj8GjhTugVuqdxbG+O99SQlCw0LCNdiCpph?=
 =?us-ascii?Q?CcEr3isr24ME3hdvhTOZX1Jg+DfOn7OtTAzAbJ4bd0VYeRncChWmn6tvM9eJ?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2364a1-a4c1-45b5-7a61-08dde73b3c50
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 20:32:55.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRZAKJoBk+5HutRnTH+/mXfoJRjZyNdVAOwXwWuTKCNsvDbbY5NAGWi7m9plnwNvJFmpHFvavn2lSGtTXULcErwnkALACd1vaQtDhCOTSLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8452
X-OriginatorOrg: intel.com

On Thu, Aug 14, 2025 at 03:17:15PM -0700, Marc Herbert wrote:

snip
> 
> If nothing else, the comment should be a bit more specific and mention
> the relevant "nameref" or "indirection" keyword.

Done - used both keywords in a more verbose explanation in v2.

snip
> >>> +        if [ "$expect_failures" = "false" ]; then
> >>
> >>        if "$expect_failures"; then
> > 
> > Is the existing pattern wrong or is that an ask for brevity?
> 
> Yes, just for brevity and clarity. I mean you would not write "if
> (some_bool == false)" in another language. Not important.

Disconnect is I was thinking string compares, not bools. I changed
this in v2 to use builtin true/false bash-isms

Thanks for the reviews!
