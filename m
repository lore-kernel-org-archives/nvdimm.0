Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A643DE425
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790718340; cv=fail; b=jz+NGLtpdiCbWMkTu44bVpFj2j15bHi5o8wmCil+o0YqZptqD9q5qm73fVcHXrqJi0oAmSxvDi6RnWGefBL7LgIR74tO6tNcw12AG5mmNMmNrJlAV7VvKGrFLZ4ijrRS7HdHwHMLxkaJCR3ff1GVvAX+GnFVBRo8MWPGNICKYHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790718340; c=relaxed/simple;
	bh=6kQGgfVtuQGu+gEU8sOusYZebMwbO5gZOoQiSLoTqbE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GNAXt5dQvh9Y/BWlAw0f6X4vGiV8Xuu5kb80nLZ/YSZCIInv5WtlVRjkkfKv18oJGVqtRTj54xa5vw8mq6r8vrOR69NhxZU5vd/Ogva0E1oDIz7NZjK5L0ve/uDe7tP92ia5xDjDGAkMruKJ6TcetDu0CcKza4MMKYNc4MfMdKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUhGxPBW; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUhGxPBW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790718333; x=1822254333;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6kQGgfVtuQGu+gEU8sOusYZebMwbO5gZOoQiSLoTqbE=;
  b=hUhGxPBWZuUy+aLxWxifRqs7FF4Z70QFHYlbBMkPI2JcXDMH5xAEILxB
   tURMnn0Fp53Z/x5uGh7LDraHZmRewL7wC8ly3OCz4KGWKr7LWGEm/7LjP
   0Lq2CBunz83VlJ7xEs7KSEfV2DhO8CejaZw45ZfsLyPvqB1t5qhruaggp
   nxLfceuVV4nJgXx6/oEap7UYi6tAEYEn8k6ss3gojXY6rzLLrofnnSHCM
   6XluoQF9PC8yYam2Oi3eKQiyQc8MYnTpbxSZAbspni4tsTKyqEhRP2t1w
   ij0xespnEFo7RZV2c7WSusimPRooI3enIeT0NfimBOyZ3KlNXQ5TTmpg0
   g==;
X-CSE-ConnectionGUID: j41GaInuSmifsZrl37QAiA==
X-CSE-MsgGUID: ehUbD2vPRLqn4Q0+2KkoXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="101610847"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="101610847"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 14:45:30 -0700
X-CSE-ConnectionGUID: Tf4eMhTvRO6AlUD5YiMhug==
X-CSE-MsgGUID: jhbgqKgeTYu1bSAab1Z3aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="275526169"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 14:45:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 14:45:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 29 Sep 2026 14:45:29 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.19) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 14:45:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f045+P0tEXkznThUp9AO+b4PIk9vIlsuc76cOo/nC0VnVAt/4IJZYlHgR2Ni573Z+ngO0v81oTlF8GA9WT+ieuiPn1wJsvBcfh2RNvZjwc40dYwxqKQAnjeImkv3QPla+vCSQWrM9QW5cCGnotxVOC418Iib+55Hz8DZ1FALoY84HHvX2cYVhw5ePO6ji4sOkMG33iqz2WjjnxiGnaO6sQMylZS4IedcKrXBCnrLHS1uQQPoK0Vf/n5UINqxFmZzxl5DBoyyV7cMFfuzZn5Eeaa2cQ9TyDXmXFV5WVlF9xELtr96mSgIxfIdjW/BRuyDgxL1yG4sCoujoIIYJN4RZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVxxNmb76F/YgaSz0JB9gHWpx2473kBgMoO2ofCDyrQ=;
 b=EFtE4qKQE/raqPd1htZE3hGVM8wpL2Yq+7JiZakA3JG2h8jmhcJm+S8pI8Wh0x6lncYgivZLaeZIeR6feao7hDb+Rp0dGBx+rWmnTaSc2rha1RaA3oSgnP1TDu7TUxI6aO5vQuKg1CW90Bf1AiTs1gNVFozyXmmA4eh2nhfZ5g18DeSwTpaAtl99jeNTr5LN9BmwIS7CnXHz6PjNfbVzQY77pV/dTV5/GwfDj/CTlXoOmbgWZJwLMnunLSRWrYcWPrld/mQNpS0wmVUFgEH9urKbtEm7yRqS9+JriI1Ta/LNAloZVvCk5f4zL5wwe502S7DP+NEkX8Is/1XaaeGw6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ2PR11MB8568.namprd11.prod.outlook.com (2603:10b6:a03:56c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 29 Sep
 2026 21:45:20 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 21:45:19 +0000
Date: Tue, 29 Sep 2026 14:45:15 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiale Yao <yaojiale02@163.com>, Dan Williams <djbw@kernel.org>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] dax/device: defer publishing the dynamic pgmap
Message-ID: <arwxa3BryRJ-Yqo7@aschofie-mobl2.lan>
References: <20260927114736.1113965-1-yaojiale02@163.com>
 <20260927130526.a6da56f1515cf1772cb45631@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260927130526.a6da56f1515cf1772cb45631@linux-foundation.org>
X-ClientProxiedBy: SJ0PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::13) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ2PR11MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 33062554-f3cf-4a8c-ff0f-08df1e72f502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: ayEbycNPFArEYzwA3q9ILrhice7C5L/ZsuLt3uoH9CdPggqJwvV6+45NElcVledV9MDflP/yJkyI6ATrYfN91lzHwh0KP1NZieNTezqgMz0OhSJk2UUEalNOXh2Z90cjXoQgdoEtFw0//cWdoijxo3Do3CbHKs2/hEeqcMWtuXgPKGRBsHF5rvvRA4eWy23E6nAiPbVeTKs8xwww/w5yAFEYnCSjGBv511NWtexqYlmQcWKPH9DtKvpl2KObfojhovB0C5kUhbtCc1oNS8TPQLfPTALplX5cjQudNb8dTdKsc9Ue3eq+8mG+qz9ckPtEZ9wqNPnqU7KwIJx7AilCLGtqeqG3BPkyEwNpx43Bf0jdznc3Sg0MWqpmw7P04KlL0w9ggwKTR0UKiVoCuzO1uTmyv0Eg5rN8613G9/mh3l+Cs4hcyZnG3u2iVPjaMC3tXkly4se2OS/vZWH0EiJcDkVSNnJZzMpSyjf4ZNx4fFg2bsm5hh4Vwd93u9ntWZXseQ7+WoN8sBvgEElrQaBA7DWfLDz3PFOeG8aqv5+eJzMrhN/dnVioS7Mnigd+ZG0AAH5FkNXRwEhjZOwFLHe/n8m11YBR0Nix+QTNK3Yf7B7MLUJs4Ium5HCT1h0WtnLbYarsX66Xaw853KRxmeWYA4fJDUWTuT6wv0ZoA4nqcgw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LYb4ABKPd+nSUR+3/iRUvM4bJapD6P7jNozwUSbFOgroaP4EnxmGu+HWoGZW?=
 =?us-ascii?Q?Ec0nPdehVivFMHvfmj205oCMSOh1ZpQKwHN2YHevd3lbtDP6OGWZMOGb9Zun?=
 =?us-ascii?Q?P66Pr3nldEiEMT+jULbo1NiUk7i7opr2Uf4mlY9Wcq0nowX4U9WQn3TzQ4em?=
 =?us-ascii?Q?S4uhe1pbtnsv5iQpVch3y1jiiwWJ6LiDQqEE3rEsRIl/Z+63JDmwCC35cUj6?=
 =?us-ascii?Q?twXDR8bFckpeoVq4evUITb74iQ62U2nplApD5pybVCyrMMuc92pei/TEKVdT?=
 =?us-ascii?Q?3GFb8SQ6HJ4RNVu3mT43pYIRU37KWee+TNQvRP6a80YyiODd35lSAX/lFoRs?=
 =?us-ascii?Q?oUAUu7tVHR+CWeertx1d5vpoEGhFv68KjvlZxv75sH6OJPf8jcoeEbDYh2uk?=
 =?us-ascii?Q?TVIcdH47QVCPHbxcn+LCWkYZFyQtuz1rVC9GzC9Dy38f6S16AmrpxsZnhdHF?=
 =?us-ascii?Q?KxTNxLUl8YCWPSkWylUJTdZWZskZRNPMIGTVAtLbgUzk4rh2MQJIKovxjbDz?=
 =?us-ascii?Q?5DFcMVFEYxaKtQvoo9nz/mjGm6Hs33CNSLFvM/E62lxGHd8XFJ40i60eH42x?=
 =?us-ascii?Q?FqhwGfFmCdjOnUYbPphoL/fG+IR9s+M8jWugR4hh7Xrl3kX4nf/cfDnU9G7I?=
 =?us-ascii?Q?YaoMKufFtUk7JltBw47PSy4KbTrpBpxTPwPyGYstqir2btlfoND9AxZQBYKd?=
 =?us-ascii?Q?0bW3+agrQpYsBCymSdQajjRQApANKZGrxkYUoxoy1mtZxTztJhl9Wu2yYWjV?=
 =?us-ascii?Q?c4Tl27YBrdqTr++DkFuT2rDKPZlQz17wHucYQPLqTCLMixHQfNjnahbKezOv?=
 =?us-ascii?Q?8sxFekGE9fWu+g4VT9xkNlWaRQKmtUsdIWy1wvpamQSutJeCX1ce5rfVhvpj?=
 =?us-ascii?Q?psGk5Ob+NPRT3BUqRdxCqNgaeJFlUtO+OB4FMr2ubNC0mG0R8uoIJ7zWpuOL?=
 =?us-ascii?Q?mnhXmdUyTPGYVCG5ykMydzlEgS8PHdW/ks3E5kgfEZV7tABya1sQRc6iMTA8?=
 =?us-ascii?Q?dxIxo0T3AJ7BCT5UhUawL8bfwaIK0b/SO+2PfbnfQF8MYxgCT7elwTpkhV9N?=
 =?us-ascii?Q?bU+Rc1g1Q01Wesh0GWeZtVJoklZKT1F5AZ41EM3McGRdMupyI/TRHhOlsMXZ?=
 =?us-ascii?Q?dz3vbwhP2bQ7uI1dShEhfRGrnB/wLxC5/fjvM8Y/DEscbqBVzng+ggyT4to8?=
 =?us-ascii?Q?FGgWaq3CMi6VrzrjGfhbPLokJd/KZWAa8KXzTjOrnNXKNRC+RO4RoExrLB87?=
 =?us-ascii?Q?dWyQUQtiZA9zPeETSUDvBLl4IU1fRhEEQltqUnugKmj6V1dOv+dtXBnD36RT?=
 =?us-ascii?Q?sHJZYzneMtIrWMb7D78kwFBjtLYwURBkMiy/7NqNbWomV9bGpn8jPF/DRohP?=
 =?us-ascii?Q?nJmikGgCECHd887p7vptY01Fj2nk3eXU7KOz5WgA9y4YDgMXLITfjMGihADK?=
 =?us-ascii?Q?6X8jizXIMRS2/6sWrV1E2nPbRUL/OoBNmHBTQkvqaSZc24dkRih4asINBRFc?=
 =?us-ascii?Q?YNM+YnhuMqdQ3tXBj7fZlAFhclNVsc6QXGEcTXVsZLEPP9rHJVM8DfKs6Nq0?=
 =?us-ascii?Q?Zy1xZzaOS+MK/jBeOQKCQ+InGwx8LJoTHdt1qrxqb5F2fmDNbttjdF7ivlZ3?=
 =?us-ascii?Q?JRbgOtTBlVZ0yh0SCEj8EIbxudSTs3f9Ts9auYp1SOifPPnIKawzAGeL/qzU?=
 =?us-ascii?Q?zzJ1ixFDl+fQ3YTdZxAbbjdjGy1WPyGHCTuPrKvsZT+dcgBZgCEY7umFPECU?=
 =?us-ascii?Q?wMVe8XMBVBXR2hMi7QsIjfOcIL87G7o=3D?=
X-Exchange-RoutingPolicyChecked: eawZHymcLGEsoHfQ+XJoTaGp1o2YbH1g/hOYo0JGLWYpybWyC/F6B6EZjzZxgIOzWl6/GUo3mz8fQn2p79nB+ObR35RMF3vMMkWnckwygQL1AgmJ1/V1AGjxaj9dGG7XtWFT8wKqroI2z9tUBjX6Abz4k4M7H8MFW9zPUiJQ8HflN3PSdjZn7M6d5B+XfZVygHSK1+qtFkFkzjtVlBvI+3wVyVzc0nJgBFQE5JIq5uk2ZOp0I9MqhcL43CH9Q0TrQpSs4QL5TxEISE03Gpfn7ekeoiPuZh0E/vBI141aP50WdGma57Diryl+Lxvy9aePgH7BqdQ1hXVzqwVdHhdxdg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33062554-f3cf-4a8c-ff0f-08df1e72f502
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 21:45:19.7417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2DgjEgk21xB+F0h4UlDNeectcWD8o0qfQYVAnOKgUDu68LOSnSHLjw1Q4gqpKGOhLowDjTL1Rz7GIt0zyx/8bQGf21rTbquNx+bOSlMizU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8568
X-OriginatorOrg: intel.com

On Sun, Sep 27, 2026 at 01:05:26PM -0700, Andrew Morton wrote:
> On Sun, 27 Sep 2026 19:47:36 +0800 Jiale Yao <yaojiale02@163.com> wrote:
> 
> > The dynamic device-dax probe path publishes its devm-allocated pgmap
> > before several operations that can still fail.  If one of them fails,
> > devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
> > bind then fails the dynamic-dax invariant check and leaves the device
> > unusable until its region is recreated.
> > 
> > Defer assigning dev_dax->pgmap until the final devm action has been
> > installed and probe can no longer fail.  A failed probe then never
> > publishes the temporary pgmap.
> 
> lgtm, thanks.
> 
> > Fixes: fc65c4eb0b2a ("device-dax: ensure dev_dax->pgmap is valid for dynamic devices")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jiale Yao <yaojiale02@163.com>
> 
> I'll queue this for next-merge-window as it doesn't seem very urgent. 
> Retaining cc:stable.  I've marked it as "needs maintainer acks".

Hi Andrew,

I'm wondering why you are picking this one up?  I have taken
on the role of drivers/dax patch wrangling recently (past 2 releases)
and was thinking this fits within that group. Not that I don't like
the help, just wondering if I've misunderstood who does what where.

-- Alison


> 
