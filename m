Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795118135;
	b=GDT6K9YH0IJ33h6gkaGN26P2Y3tyaUlYEOAJig5CrZ9p7Ipdtnde1AfXZf8KbLj9c7J8
	 4ql03vuF8RtUp4DPMMvCa1NNq7ZHd2GG90q1H6boi5U85BFMrjF8iu5NGUvslqA70mQ32
	 zbEYUHgo4Ymk3+gc/DyKRHHuTYJIZNmICtLxasLyBlYvDPq1SfM8fZgu+CSNH0eDpumDa
	 BfZDG/+d1YD4CBOvyQIO+Hpdku6va+IiFeH3ZoWlaVLzZJJ8E59Ioc17XvCg7XU70ReG+
	 qyKb/xDJ5W2zxijQebzy22IAMPaF99mNmIgYuIba3NgWVTaNPM7GJuV0I9hdiVs5Lpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118135;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=kU4TtAtrcxThbCHrAYeUHeKD0TIruWLo3pj/Xm+ULwA=;
	b=i2WFEOsIg8A6TyrohifwV4HFDvuI4TAZTx+f2e7auRhUN3PnxiAnjeO86BWhZ74s0dN7
	 u8xsrnB1hcMPifxxQkeZhsKoVtIci4GE0baprHk5YcU/23FIWdkKBNCxP6XDkMyQqXeL7
	 GXAzJB4tFw2LBHldOjLjo1WVg3KVnGmOkUmjf+aeC/OQDQ1KdEP0OIWlrfp9QqHjEYaKf
	 BXx9poyA2EZZudO7Cv/jj7LyAiBiugQUTV+HRIq5sK97SlrvVE3fEXaQtJ0Fi5cnFaA43
	 PV2819jBrUKdnaibavukBZinKoSOAVLHRA98rU8YxpXnSaFCM+zfTYqjH59aqr3Giww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qm1gineO;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=MR1uJiWV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD1D606A324
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 19:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AD1D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qm1gineO;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=MR1uJiWV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118134; x=1826654134;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3vRW8HjxdQLsFZv9eDpdoAXnMeP4/Fa8KllptwoP9ww=;
  b=Qm1gineOyyWdnkXenrMHkIapZbLrs7Fg/BUT6svV+3dcsxUBzw9d+vN2
   SQrDM8k29IXA5FnuccqNvDFTr6wckmvreTew7CNt/cKEusS0Jc//8Z5Qi
   dnLmlAn0PVkwpPJbNG2Ppu3w0TY4Gb/gi8nt6Z7G7AjxMm1XS7sND9GPC
   MgUe9C31q2ja5hRoZaeHfpvCJ6qWILd03S42YCNEEeUG6J2zXaM6kPSPR
   wULXU7x440BaPRmGUyT5vpL0kCuNuHi4wg2rWz865i6Jz23qxQNhp6BQM
   Y6x27RR2RsxHLW/11eBQX9yiFxk5iodYCihQVEXXogp3PlayqnR1sD0Xh
   g==;
X-CSE-ConnectionGUID: Vi2Ul2vETKSE3ZfkgGaE0w==
X-CSE-MsgGUID: ZrXuK/bbQLeKBgNQoQfqyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4003147"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="4003147"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:55:34 -0800
X-CSE-ConnectionGUID: 5Q8qheWtT2OhXxi+SFjb5w==
X-CSE-MsgGUID: p8QIIvp2TTWvaEQo/boS1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10528760"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 11:55:33 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:55:33 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 19 Nov 2026 11:55:33 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.28)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 19 Nov 2026 11:55:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayzWJJve6sGuVyF6ufeV+3faUc1nGuXVIHfuj+L52Mw1zEJcQht60wWXhXjlYvuFvUCHkkNB9UAjxxr/a9UDGm3+LqUdzxRvBzWCti5RHOh/JEeA52lZVr0Oei3iQlGj5g2zR/P6nY+oVzx1BFkJK+99b3i2lIvzRQw/yhVOxftnDz9FtUs/xvJX5BgGC2THcB8Uy0u8mU2RcRGphmcXtRJd86eR3L3H1N9VeN7ffyIHwpYUGLF996LUYshENC46o43rxbf6cJqnk5wrEFYdQakiFeq7pZ4KWHVh4IZ2+rreX9ugkldYxuwXcO7zZgQsetH8jHi0wFjarG0n4F/DiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kU4TtAtrcxThbCHrAYeUHeKD0TIruWLo3pj/Xm+ULwA=;
 b=X00EG89MhVW2qtf8jcOxY9ZvgQ5hRSR/lLBJdnfusuEVG3F41TrHtVSPqyYbkj/Ze+eXXulLWesu+Zq+LZTf7tkTyQKiKnOe7bCLgrdiaD0BzMtkRCTYzrvNb+ii/s2hu9Tg/8xb7b68nk7KU+DP+8PDYJi7VooFvUtoklCLknrlcyrjoJ69r61Hjmtq/41cegH0tSRWv0KiXIFIMM35fjoZZ/PMR66eGVvgEyR9TuyaEbB7p21B9ukWtaRZrGBJROblFDZaB0hsxbhPMwyFSx2tYuLnCLO1ePN7Qr9fQCy5QbrQKQg63WCyf6OrxcH5/We/CDnwSHguln8jgMu8Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kU4TtAtrcxThbCHrAYeUHeKD0TIruWLo3pj/Xm+ULwA=;
 b=MR1uJiWVingQ/QraLED79NTCwLRkwgXLJzZ67bXqc7ONEK/GZ4wTIiaymFJ4rU+ODwjCZ23X4NQFtkB6Vw2dAVhfQDGoC9AoEbaf6h5Arcl7dVO/BCk2itIIy4lGt9492zYHSkjAyTy8X76QhjHztIlwgILEh73ocO0F5rmrRSc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 19:55:31 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 19:55:31 +0000
Date: Thu, 19 Nov 2026 11:55:27 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] Documentation/ndctl-load-keys: document CXL
 passphrase key recovery
Message-ID: <av9UL_T-_KyS0qWc@aschofie-mobl2.lan>
References: <20261024011706.552346-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024011706.552346-1-alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:303:b4::17) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW3PR11MB4763:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a9db0e2-f783-44c1-1011-08df467710de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|261009223027099003|18002099003|22082099003|261021121427099003|261102123227099003|56012099006|10067099003|261026121527099003|11063799006;
X-Microsoft-Antispam-Message-Info: xtCMuwLM3ODmOY3k1Ffe1iEk1ZFxbF7rcEBm8amLpj9WttI+QPANP0rvM7ANv7cQd1f7oBuIKC6XZ52kabPha6zljPYXpwCXnTJT/vqZXIwX8PhzAiQE7Pjrmcznuw+XDyCbS4jN10NU1uRNeew5Ubo1/HB3k/VBqwwdLaogsdO87Q91OwKk/IC0XRKYwMBYXIKghLvF1Bs3kZbOW5qTG8+fD1c5ZnMhxDeasklZfFwOdjzqZIZHemFEDzC2sCjr1CXH7H2glF278Bttx4ef4HKPylL5nBlM4GlXN93sNGeiX4RgNXjhEz6y0e0L8azXSJDVzlHieloHO6arp3bVZdIJlQjmdBlYwg2DuwCB4uc30vE07D21zTpvxNNJDGpVA632Rn0DTwypc+8/DDGO772Qu57zWG5AtKcIWgggfeQ8Mwcm3jFs2pwsYuPSjn3WxDgZd38lM3ZV2z3oPg0eQHVBvqP61eTDvLsqJSNcCBSRxplCBQR+yqFvrh6UfJkM0aT4wxsKzZqdUKpmhTRGuX3EHwXlRh40E/AR7R8zTG27hoUdTQ8cAW+FP3xVURdGMlFQVuswTOpvbDN0+o1Ux1B5KQYbqvxP/dDWL2M2th17ZV81bu1aTQ+Pue1SmOTh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(261009223027099003)(18002099003)(22082099003)(261021121427099003)(261102123227099003)(56012099006)(10067099003)(261026121527099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PPeICRZjLvbBvIEZe3S6ZKbpGoah9Y/4p4HelAEd15xRKYga//2TdaqLzGXd?=
 =?us-ascii?Q?IGiGtVrRccdyzhwlOh7g35UOlPTnEQgndcEHMTty+7Wty4Gz2ZBTUkKZ5Q0Z?=
 =?us-ascii?Q?PzQkzKoby+JduwlRt5rXVDdANad9dN26UEsTFulasC6D2vf9G9NG9sddrjiT?=
 =?us-ascii?Q?S9YTTFn8N7zcOS5Y02ekFzowIssaRSNEL37shNaKWk73E3OasR3w2D201zfm?=
 =?us-ascii?Q?xr/6jY+Uz8J72e4KqNOSCeoP/PldIgm4fXXkMCilABfdxa5dufwZvMGESI/h?=
 =?us-ascii?Q?fy4paB3461Z1nPYskUv6Txjo5PljdNG/2nfKZo2gq7A/yaYA6plirotn1R2v?=
 =?us-ascii?Q?362mXHJHTHbI5luT3+z+WEvB0khq2+bLHJxjghvCzjIHZfNDisGEcpzP4c3S?=
 =?us-ascii?Q?7Yj63o7aH/ag6/bPgwy/39NS/H1Ez2RNMkes8TIwf3cNSyNQaKoWlwNfcgv5?=
 =?us-ascii?Q?H/WJ0IzVRfW2eQ3hwBISpjY+OAi0pGjfl9bja+8v8Epn8sTeTDeHzRC+bLvz?=
 =?us-ascii?Q?xKiKG064iWOa5eWTjw9xTV9Q5otMGFoYBOUN6//bc7NEHfWtD/Y5jQWYxIgd?=
 =?us-ascii?Q?jrcNQFfTHLKv5gIMmVxFrWyaiy5+7XLTzkGy0stx2ppH+9qdx4s2R6YZxy9W?=
 =?us-ascii?Q?kjDGfZ12FYqg+I51tuPURMVagoFH+Z8/Pu223lnSWfYd7AlqpL4EkycVeSuA?=
 =?us-ascii?Q?A1IIdr/fIPFNIx/BvNj+EJncEXlXDMWrFFyk1Vs9dwFJk5+nApiAcdXkevKE?=
 =?us-ascii?Q?DkhcbRxmzrak6BF6+dPACE/3VGU/rGLVhJ4944q909ZWnLOfslwPOi4G70/y?=
 =?us-ascii?Q?CefE4civrUFFCf0zaAe8ZA9lQvwQ5Opf+HBTz5Zr3T2bLx+z0KRXtwxhgOdj?=
 =?us-ascii?Q?nSM/C4LAsHtkn9JZ5bMT0QK1ybwQigkzSAmn6lsr7X/X0AMbE1hYKTQvUR1Y?=
 =?us-ascii?Q?eUye+zYGF4T/03K+KwbxWoH0VAOuqxWAl9ZWSDI4lLeYfIx/fUy4YmXvGOpm?=
 =?us-ascii?Q?6SwRo58zM6Gdx+VnKsnI0o2F0QO9QynwO8N7nzIdNZ9C59GNA10THLAiKhVl?=
 =?us-ascii?Q?WZFGPU2vQze2L5Q0LqBgt+VTxUJ34YQ0TRBZLqsKNJh+sfY01MZlV1h4Uo0H?=
 =?us-ascii?Q?fMRRd2g7pIwmfpcFc+q4S7UJXnGaTgdrtTqA1s0re5cIVy4J+fvDboClLDKK?=
 =?us-ascii?Q?Nn4C44KmITS7kp8OMrmOQyG43liYO5OeVxXY9peZnpV03zolwAoi2Jjao75r?=
 =?us-ascii?Q?NBKTpzHr3ZvqYM34Kz2ivrIMy6lZywSUYGiMgehDwMW1enaRcFJKmLVtXnZT?=
 =?us-ascii?Q?6rBwoJn84osMMrJSgILcblNF5C8SkUEk2sjEi/wRieoD09V971UouJNa36IK?=
 =?us-ascii?Q?rC3OmgTbtpHm+BWUlDhfyv1zCqYp8rx5isFI+vGcpwdWDWk8yFDwWGu9e9Tx?=
 =?us-ascii?Q?LDTBSOLQg5LjFrUL2+FGy0RI3G8QKQZZIFwQV3KnGEvXIC60XeceCkZtx0vw?=
 =?us-ascii?Q?jhIEQZVXXoweyzwZfTofVGnQ9g225HgnwtMeas5hASuZosi2JxYOvj3tSTWY?=
 =?us-ascii?Q?w9G5Aa66csjg23kXZjsU7Gp6TWdaKgZzyBNsHSxH7g9IfTBIfcfeHaGCPnhw?=
 =?us-ascii?Q?DwlfcHUgPVtxvqLLbDHFRfYqAUcNpemeawXn+XGORi0wTmauQVdfNHRwxR1u?=
 =?us-ascii?Q?S5fsk7Atv1B7lKmTsVKHXt6INRAwNZ6pcHqFfToKn0PxSLSIpKV9OGXXW6jm?=
 =?us-ascii?Q?K9epOaioXzdjFZsF+Y6Sng3eC+IQTv4=3D?=
X-Exchange-RoutingPolicyChecked: ntzWs6T9HE7ai+7ABw5+noh0nZ8k7hvfhHLHvKTVgSUd/il11NqYXKXiPR6PUhuplE415x1zUHoqnso2vV0HuwKZ/q7LanvUtFTErjOHrsNJRJ1R1GKrpllfvHJUkFkoyBNrZ7hGK+4KXAuJIWLoV0rCZFX0z4WtBTIWPe+6Joyhi+oUgi92qVj91QzEcJlHpySCj7oMzlhXbAVHPQZQbbu3SEBeU6SGxf2iJmZKEzFFP2bzZ0427OAEw3PxIyPTBhwS0Pl49l0vymEnyKouXxqaX9YgHRbH/KnCZBxBeJC5aZ2H8qDDYqzMrouq5K23HfQ1xiIqGX0aspgGT2G/UQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9db0e2-f783-44c1-1011-08df467710de
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 19:55:30.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wB5iL6e6SU4c1/ybeqeEL/G+5rXlFiiTmpI+n7JjqMGfAiR1eU/u61Y9ttKTCKK8MVFiYPqHuwc9SHSA2BMccm8Ip+nggbogx2sqrUGNIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
X-OriginatorOrg: intel.com

On Fri, Oct 23, 2026 at 06:17:05PM -0700, Alison Schofield wrote:
> Kernels prior to Linux 7.3 use a different serial number format
> than ndctl when looking up CXL nvdimm passphrase keys, preventing
> auto-unlock after reboot.
> 
> Document how to recover affected devices on unfixed kernels and
> migrate existing keys after upgrading to a fixed kernel.
> 
> Kernel commit in v7.3: https://git.kernel.org/linus/8a80d3d65cd0
> 
> Closes: https://github.com/pmem/ndctl/issues/299
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>


Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commits/pending/
