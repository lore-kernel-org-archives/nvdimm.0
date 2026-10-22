Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792634395;
	b=QzdWvo1F4VY6yJcBT3y1bqqDDaHN4A7OxxvEDojLypTwEzZZ2eQ89qDv8h5GD1HAzs86
	 VAqMmOZSI1pFUr06yd8MU3KtqihzhS+bPt090nZzwSkfWW9M66EkJW1wPuri4FmrQaUiQ
	 ikL0P0LWrgVPYhbsbIlMVBFGOh0RM99ax0gm9KomrLGpM1Okw0cnoXOLXOMlqkp8WLQ40
	 bKkPx0g/J/mdGmRU8vv93ykQQrtAJGIhx4JslAIyGq0goLicZqDWPrIX/kLzRT0dlgcAO
	 QdfF4ezMD76EPLz+zFm25xyGyqGcIoNO4IvHyMZ7lVMPyjGQbsBLnRRkgJwByjH/yHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792634395;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=Smx3vBBmXDtKw7m5OoUTA4eBvnmeGgYjEUiQC4xdCBQ=;
	b=Osmk8ozNFff0HPMSmG9mv+NhtM0PBU3qFye0WVElUNDpoKyNz6zG1fyZPT0CQpLhr4vX
	 VwnYF25pSR4Wz1wDcvsUWa3g882Q4qSVRAygvs0C2FpTPWlThOV+Sf9fHSD76VZDP1g4B
	 iLZCMBnKFJF1C60j4tm8I/B2CN8dEib4qkYczJSJYhCoExPTr/BJgfMpWAqprSyNhmwLG
	 qXpZpy/OejehV4/tzF1KysKqwipPN6uRc7nPQUR0HRAvxpLJB0b96qz02dqZ0Dj6o6qfJ
	 aN4T8SqQ2QDYn62dn0opxd9CyPZ+5w0cUtmxdXumII3obAy3bkMADjmQRJhtWhgeRyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="HJV/89NQ";
	arc=fail smtp.remote-ip=198.175.65.16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD81F606A31A
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 01:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD81F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HJV/89NQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792634393; x=1824170393;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TGrGu5MA5TVmUcKP5aKMjPOPdhxqQWc8btv/bP5JLes=;
  b=HJV/89NQItXWUp/gi3SqKrBl/ejDWl6z4rknGp7BY3WhVirDEqXr5pOF
   +hxsgGeUInGgNvBUA7rnE6mr2aHq5IgYkOx5Kzo1HeyIxfHmd+zuU44qI
   EqBvHYpZ4gIEKS/1fvjgjnosmQjR0cDsBVAv/Coc5phd7clp5jyz7RaTM
   ltPzplzXt2H+vBP+a/VaCAVrBFemiJ8IOoyatdSx/6KtT6z79g9rDWL+L
   bkBEIfmqdWpcJ6ZAd2jwej3ylGnRU/kXaPlpdj+Zlm60CLGp2NNfgQnRN
   pn57r7x44tWaW+JuMNIie+GasdRdQ/lCtpPzYkXRF0kSlGyk0jkJ1cZhW
   g==;
X-CSE-ConnectionGUID: kJ7DHnFcT5SrPRO+nvBaZw==
X-CSE-MsgGUID: DT1AswlJRTG7Z9DNGls8eA==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1362244"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1362244"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 18:59:52 -0700
X-CSE-ConnectionGUID: sFwrlUjDQNie0Tnjr91lVA==
X-CSE-MsgGUID: VK+SvItDT0+WQOocJKI7gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3362032"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 18:59:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 18:59:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 18:59:51 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.42) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 18:59:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2GGH1GeYEmu386PTKOI7T1IZeS/ggoOBDJiulL46H/PTV0IQBNKEmVj/sHJg8Uw8Q0d0X8IkF4t9loqpsomypFFTiBJcuapAwduwUush29kMJhKwMEAy8/5g2yRfGOfGRa2h2xy7IYX+2dFCTCxlJsQ1Ajgf0tygDkh1Nk8fgSeXengttseE837JiwJaUmcB/oT1wEJ/wuO1PLORu6LkPxFYlO69+6P+vzmWS5yLl2KIailt+9wYvnVjfuZRROkb1v0sVlVO090BxbNt0L7a1O3wDuL5RhEmmNlZPyBsN2nJe6e86gll0c84sn9ORGphh1qtT4tv6xcYF7u4pesMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Smx3vBBmXDtKw7m5OoUTA4eBvnmeGgYjEUiQC4xdCBQ=;
 b=pO+wnb2LeAA5202PZAds1IVOxiGFAL+UHQgaRdLjDkZQtMCR4+G/i4N/ZsSafrIencMlusHUrlRZqae2qfYB52DG2C9d9zPkHEfqNRlDUtT8G9yGmjSxW71DvGEFhjB2f/SOcMBDv0874b0DKzyq77hWZ3kaDdUp4WSI2DPj5+nzjNDVMeZKIl0+qxfCeD5F6AP+xCF6f+d+iqLNmi7qv2EZuDQKePy+MePkVDXPpjxni6R/BB15pvvHuwah7rzuJ+Lr3IVnw8iG5NeKjmc8fcJAXk/09FMnaQAuNdsdAA/ftdPzZ6rHlT4DTfzSNS97zoeAlz+2PFlNHW/pdbHBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 01:59:49 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 01:59:48 +0000
Date: Wed, 21 Oct 2026 18:59:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 0/6] daxctl: use dax kmem atomic whole-device hotplug
Message-ID: <atluEdaffcWYOf_0@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-1-gourry@gourry.net>
X-ClientProxiedBy: MW3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:303:2b::7) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW5PR11MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 254a2581-c8e9-494a-1c05-08df2fe026e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261021123027099003|11063799006|56012099006|10067099003|261009223027099003|18002099003|22082099003|261021121427099003;
X-Microsoft-Antispam-Message-Info: TqmVuDJP4iAXHWLc6fEr62tqiHlc0VepP2LkOU+Cf2Ycn+d/mHfy0SPTSKbxJ9SY/GchsdRcuXw2/8oKoVQOI5B7sHcCOTJgp5c3Z0JvfMEN0yI4uBu5b6hhFTwjTXNAZ/RMk4kddjjng3rg+tdNTAzLvHtnp4/Giyt6m/w0qRlRb3XCckGO/ST7L0vLUEV1L0mDVDA1SZu7InnQD5JeLAI+uZtNtJTRIY3G35Xc+RmXBxDMo6oEiNBawPk4RU/xSrYF+lWBN3n0c80iQo2XPcECBNSasdi+6WROcJdgiqdNkbRwawTGgsUz/B4EsczSwaiy5fp9lO6Ny7DkKPg8Voy0a8oTYBB8BLd+eITepGkgnXjHC6amPwc6YJNeiHh3tDkImOMkIcOA9BtyaBawtSNaQ4DuEApPfkqb77NYYPOO0Q+oY+OoytzSg03PWa/L4giggqA2CWAMR5xZazkM/3rvpYrjbd2Qhi6E4bmdcNq8vkz+nrp3SzafnaCGakkTZ9TsQyxDsrD5XGCZGctjfP52C774Clx16DFMs8kq/rQsigEGSQ+Hslj2YjY46//0Tn7uF5Q4lCiy9b0f8ATv01sOVz99rABY5A9TF4rt1IehVgqcogTizSFSUo5tiZzn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261021123027099003)(11063799006)(56012099006)(10067099003)(261009223027099003)(18002099003)(22082099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vgd30KkTZWmTuRE98yH3KO5kd8WhOLL0QKHNsTF6FsO/TZp96b8RISIEBnr1?=
 =?us-ascii?Q?j1SHL6LlWW24VC/BUzRFJS3Z56etTHNf+qbpp3hZhZpRQGn+QgVOIGi9T/+2?=
 =?us-ascii?Q?UQ2G1XD1W4KIvdM+SU+dUptcL1tJt2G2ZE2tDR9vYS3R8nJ0KSrALwmCPNwf?=
 =?us-ascii?Q?zTRnYXmZ+87fSsmg60Xb3RWWVSJFdaXbxrzZql5cj/df/p2PMaJyrS08+P5H?=
 =?us-ascii?Q?2uY+Vzqiwk0Ns3vIFCRP4IuWb7tnXbIIt7/IjvIDcIAy4H/BRwE9Q+4Q1y3p?=
 =?us-ascii?Q?su5CD7RBJJsgB3kwhVdPrlTZIKeQ8vZsU0Hru4POVccZo+h22u6xcaXE5jcm?=
 =?us-ascii?Q?MijvPpeLYkdQcyzbDHHuiY9MZIJJNuGoBkQvN4CNaPM1VyAgI8RPI9TiEqNJ?=
 =?us-ascii?Q?QW2N/7d0OXgqO1VmBu4TntLq8zUGV4PRxrdhN8YhKVeBAkW6TBqQlBWJGZOy?=
 =?us-ascii?Q?PL0L+6E+hMSnT7LuwsUEbNLFXdqeTNGRGQr5QB2zvGv4yHjvX5Gu1eksKlWo?=
 =?us-ascii?Q?HR7RHF7SOWFqZqtptLehzf1gkEvksc3iBfBF/WvQ6DV2O9MyqapOJFXQudZA?=
 =?us-ascii?Q?gLXLzZpXWcXHGZhSBYIc/KZ/CAdz4RrR53SNxFpG0MTJUSxwLoiiiSa49a7r?=
 =?us-ascii?Q?jmiCeS+eOEFL/y8kH/0mp5vazB0LXAO3PlIBBtpYyWsFo6hwYQt1mnFIEyVI?=
 =?us-ascii?Q?ah1adbLCiiTAoZ9NlTCNfR3kIpbFOBBtkoa2fk4pccZn8A/vK2Kyzd0dJ8XT?=
 =?us-ascii?Q?aJY2WKvf2S2kMiFr/HxHmhqgH5GznDxLCzrksFSl6ZZ/jWBPbj0rt+GvcLjd?=
 =?us-ascii?Q?TGI0jMAdFcpVhwxEhAhhRLy8ibHz5csNWzWhr6iCyHtxE+fhgf4Oh+xE7N8T?=
 =?us-ascii?Q?ZKrwp+ZMNGL3ESDHe9JlsPtO/rYv8Ki4Lo1EIVQt9CLSDHg0I/5uP38FWkKG?=
 =?us-ascii?Q?t93bDsgQomMQX1ZgtKAQ/YLgK6+kHjlkml6YiOBNP5fDYz9Kg7xO/OTIGPWk?=
 =?us-ascii?Q?YZ5nX9mDt1SaoGpZaBerPmuPhkaMKb+McvLWLGy6GpInEkS6J14Zmbf+64ei?=
 =?us-ascii?Q?h1zgW9lOHjkJUC68iBRs+hlg04YuLd/eb289e3XGPk+EPeq7ohVpPTDqNF01?=
 =?us-ascii?Q?0au2RPeKJDlOxhcucROZd4Ejaj+0ZvcHjBAz7LbeZZsbJTjPTq87l322mbXA?=
 =?us-ascii?Q?Dn7MTXC+BD0JSN2+ZINQ03TABRjTVJrlc50hQpITt3w86SIQ2zgl0OzdoM+7?=
 =?us-ascii?Q?3soH6UYR3getJ8zq98EGwSg33WPdP8B1C/G7tcpZajIKnSAOGLwar45KIiju?=
 =?us-ascii?Q?tlpdXkMk9/X2lu9M2B1I7zvmPz+5JVevVWHoUEFsOF/ORotB4GL9crgYh7mk?=
 =?us-ascii?Q?LTQcBJUDqJYw9C+9625MhTe8PJQzLDkMSIIOV5gqiTGTIzxFbssqUCy6BKzv?=
 =?us-ascii?Q?0bmmTx1uR5e9oBpxcSReWuf8KN+NNxK1cHb/tmzN9Dyi15KXz8WJrayrHchp?=
 =?us-ascii?Q?9Y9gM4ZIUXrDBqb6Rr0iPrfXjRpeCFiNNXoXiIW8Qe5AmplEEPC+C6LcuTzy?=
 =?us-ascii?Q?JW/m6s80obngoafElrHXcskMemLGmdixjd3WI8/FsOWhxAZMD1xsVMojeN3j?=
 =?us-ascii?Q?B7ZalM63DguU3JbNEEpuQN8EPR1u9SjL4zh2f0T1G/hKJKKa9fVWe0hNRRVP?=
 =?us-ascii?Q?fKnKc7OlkDejY54BrnZ3TvNmKPke2qw0TiBUL2aiGQtnYAFifqPtU4nZ+TKv?=
 =?us-ascii?Q?s59iEC1msANdQZzCNfdSEVKAHmfTyUg=3D?=
X-Exchange-RoutingPolicyChecked: ajt6BhraEGv5wOD/Up/feMabhqtcEQDuer3A5WFQOpx8DUj1rG1X6RLWclKk85MceC/Qk/KBEy4rpQQrttW7c6TCFCkQ8SXTqCN/xhD8dD8dMITtfK1r5fN1VWxxPG+ngfPmd7W5htV5nEEAAVAN50KxjlOieA+J2DF13JR33VU57iYhignOBeqgCivL7Jd6jzoOPUaIcI+RraH36eGAODJXclSbmuvRzATbDZfJte86Trdw0aMWRXu2x/Tc2n6jfZMR1BEBCyqoKqdXm8ZQNVf09BXfcu4EkcDNRBKHt4GnnsWxE+aIhtO3w8Z6TMMF9GnEBiyN/6enS3EXDN04xQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 254a2581-c8e9-494a-1c05-08df2fe026e6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 01:59:48.5443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxTkEsY83eb9O2EHe1JhpIF1vUIo8HqcBEkbG4MixIIJSkjFsulSa2gh423L92RJ4Z1vuFuqUP3RGec762M0Hr7aT2La8vh3jKGlFJpG/4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5812
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:42PM -0400, Gregory Price (Meta) wrote:
> Kernels with the dax_kmem daxX.Y/state attribute [1] can unplug or
> plug-and-online a whole device atomically. Use it in daxctl
> online-memory and offline-memory so other agents (udev, auto-online)
> can't race daxctl block by block, notably the offline-then-unbind race
> on teardown.
> 
> Kernels without the attribute keep the per-block path.
> 
> Behavior change: offline-memory now always unplugs the device (state
> 'unplugged'), removing its memory blocks, even if they were all
> offline already. Previously that was a no-op.
> 
> 'daxctl list' (and 'ndctl/cxl list -X') gains 'hotplug_state',
> reporting daxX.Y/state. The kernel only updates that when written, so
> it goes stale if blocks are toggled individually.
> 
> If there is a mismatch between 'dax/state' and the blocks, then
> 'hotplug_state' reports 'inconsistent' (online state / zones disagree).
> That is intentional: it flags agents fighting over the device.
> It only appears when the attribute exists.
> 
> Compatibility notes:
> - Where the unplug fails (e.g. no memory hotremove support),
>   online-memory falls back to the per-block path and offline-memory
>   of an already offline device remains a no-op.
> - Older daxctl/ndctl/cxl binaries don't expect a device with no memory
>   blocks.  Basically multiple daxctl versions on the same box can cause
>   older versions to fail when in the unplugged state.  Not a huge issue.
> - If re-adding fails after an unplug (e.g. region can't be reserved)
>   the device is left unplugged.
> - For multi-range devices the kernel succeeds if any range is added.
>   daxctl can't tell that a range is missing.
> 
> [1] https://lore.kernel.org/all/20260712154505.3564379-1-gourry@gourry.net/

Hi Greg,

Next version, please add the ndctl label, ie [ndctl PATCH v2 0/6]
(https://github.com/pmem/ndctl?tab=contributing-ov-file)

I see this goes with the kernel functionality that arrived in kernel 7.3.
That took me a bit to realized because the linked kernel series shows
crickets at v7.

I'd like to get this into the pending ndctl release, so let's see if we
can close on a few things.

I tested against 7.3, regression and new tests and all is good there.
I tested against 7.2 because daxctl command functionality itself needs to
be backward compatible, and it is!

Some per patch feedback and tags follow.

-- Alison

> 
> Gregory Price (6):
>   libdaxctl: add dax kmem atomic hotplug state accessors
>   daxctl: online whole-device memory atomically when available
>   daxctl: offline whole-device memory via atomic unplug when available
>   daxctl: report whole-device hotplug state in 'daxctl list'
>   Documentation: describe atomic whole-device hotplug in daxctl man
>     pages
>   test/daxctl-devices.sh: cycle offline/online to cover unplug and
>     replug
> 
>  Documentation/daxctl/daxctl-list.txt          |   5 +
>  .../daxctl/daxctl-offline-memory.txt          |   5 +
>  Documentation/daxctl/daxctl-online-memory.txt |   5 +
>  .../daxctl/daxctl-reconfigure-device.txt      |   5 +-
>  daxctl/device.c                               | 156 +++++++++++++++++-
>  daxctl/json.c                                 |  53 +++++-
>  daxctl/lib/libdaxctl-private.h                |   9 +
>  daxctl/lib/libdaxctl.c                        |  71 +++++++-
>  daxctl/lib/libdaxctl.sym                      |   6 +
>  daxctl/libdaxctl.h                            |  18 ++
>  test/daxctl-devices.sh                        |  53 ++++++
>  11 files changed, 379 insertions(+), 7 deletions(-)
> 
> -- 
> 2.53.0-Meta
> 
> 
