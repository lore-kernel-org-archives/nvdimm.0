Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792810569;
	b=vtpuBOUas/9mnGLHVG0g4onq0eV4Dn94Wuv3BY3vXWzO3kt/5XUz8RQEsfYw/XNZBO/8
	 E4NYaE+zMuqrBC1yzWjaFRTJyvUAaCRtkSXGvhd/bKy5EybsisuTY9MnOF/tfwCERJp2z
	 p7Z2ZeQkP+SdJcB+8HXi/vx5BQojkvUKrZ1nLqFoc4HFwPpfe4JtJxPi1iec0hjKxZiBk
	 /H59tn7y5HNuulVwUur3MjxJVEBNYwpb5E16P7ctdiJQ1w/s2yzwkpZnaZ3/VzO6ctetd
	 ykxnz39esrOF8LQ4F3sE+ctNXZHLq5hmgnrkH4u7XGO84CE8A2q4ZZMamwc5rlzqIpg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792810569;
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
	bh=Jck6o1WxGKwwHpXp7ahW8IEWuPgpTUMdzVB9okEpQ14=;
	b=m6sjM16mZGS68eXwLOfTaaxnrdcthRIrLt0o2c43IkExghvoXjX9EYT2ghXRe5KpUsUF
	 bxk4UTmC5gnAW5wV9sRgH0HDCYBuVwWj93MBQeKOUl4bsWGwedRQTmnXjlvIl2YMWk8hJ
	 P7c6mfYpFJanIuC2LEps7Yq8OtVVoRR0ibFEwu32i910ECGU0QIfgo4pwDQofs4Xz6kPJ
	 z9+s458kYmOV9sgLnYoGT3w2Qp0fZkC1TIdP+BXR3LgZDDTAmRF0pYfGcb2k6lW+8Biuc
	 YG6gVtoewnGpBKp3vr7wQfX+D2M6Hz9iaJ/fXuGPYc6fel1U+69Ly/S0lWk/AI72Q0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gra0Qu0x;
	arc=fail smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B99606A31A
	for <nvdimm@lists.linux.dev>; Sat, 24 Oct 2026 02:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65B99606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gra0Qu0x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792810568; x=1824346568;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fs3qrN9aU8O4kEopsMNbX6+DgAIV4xIwB1Pr7LPVnKk=;
  b=Gra0Qu0xhQI5HBofHz7RsTEi1X8NbvR/OKn7jB+2P3/kWMn6wLfwQVKz
   y0qW93k8EDuuSWfjtWg55L16P22q4H8dUxBawOLszNfPK7ZpqW5JKpghV
   pnzriBPt4waTuW9eumP1LAHHIM56Nwof0XDBrSpMbr9ME/ZsLiGtBlN8n
   l4ZRYhNN2Z29NQH9nOTrVt6RcBqO28nVI4Qr1d8MvE+E4VjW5xAinUSjB
   8w6s4PwWQEXwcqyHhYNilcZ0wr51cvnI1uY++eLB4A8XSaMkFmIApyekh
   aMjMmTvrvZu1+K/2OL9Gbpw392yWxnO/vEblkW4GzzS9eEqtmb6ZgQCNa
   g==;
X-CSE-ConnectionGUID: XUo2uoKiQD+y/VurLbFBzw==
X-CSE-MsgGUID: mEQlofItRUSJYHWJUc9nbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1572613"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1572613"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:56:08 -0700
X-CSE-ConnectionGUID: OafIayOKSy6REGCIS9nACw==
X-CSE-MsgGUID: RHkkx/4SRum7b6UCT4wcBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3751483"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:56:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 19:56:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 19:56:07 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 19:56:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXW+gMaWtZ+9Wys7izGKnICgV/W4gpEPooV4Knw5DY7U2pRn7uU7cvPCoLpwnrQG6A/A5+uULyU6nZh8RSqtuBlk5NUyIYeVyHrV1NKmAu1YSHhLX2Yog5giM9z7qkNt8dP7cdAHQVArZkqL1lTYBsIIiBtZ8GWtPaneajc9FA+l7F1DJpx0tPCj58B5CBSSYwVCmokBat/lZms1SQJ6lNZvxv1Wg4tT1hnHB0opyA7ZnFYyKjGeDY4L+S8OjR6Cvvt1MiCoPQQvVoC3IM+3/Sk0Y0P0P2pltv82C5SisTvvhrGeh3ThkmXA5gGuUVGkTJbNO3ox0unxSuKmFllk/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jck6o1WxGKwwHpXp7ahW8IEWuPgpTUMdzVB9okEpQ14=;
 b=bkpUiGATNpo4OE/0ZIeBbxgyspqrvSTBVndqhLmDAeidHtiVBU6wPQiTnBsI0YWfn711KvEHZEodnZlbuejqLgAeJBUZEq1ux2vDIKk1kQYADCRuP72aqQX2hW/xIT3Xic6t/BiPOvFULf0t8B36M9bBc2o5Pq7sX7K+VozAMzv39Q4ODTiUmOnNMil5N2wPs1lxttIAZLoDIVZZ+5Jg5eB4yU2/Qu/WgY4PsX38YUT/ODJykHqo5GjIDJEhGdiWpl1625h1M0XJx1/H0nguV397SE9uubXMXwKBoSgvmrAvsKiN9xxH0uvtB9+G8cY/+L+oHPps9tIwvaj98eZJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS4PPF2F49754B6.namprd11.prod.outlook.com (2603:10b6:f:fc02::1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sat, 24 Oct
 2026 02:56:05 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 02:56:05 +0000
Date: Fri, 23 Oct 2026 19:56:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, Richard Cheng <icheng@nvidia.com>
CC: <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/2] cxl/list: emit decoder locked status
Message-ID: <atweQsgrQI8NWcC2@aschofie-mobl2.lan>
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
X-ClientProxiedBy: MW4PR04CA0264.namprd04.prod.outlook.com
 (2603:10b6:303:88::29) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS4PPF2F49754B6:EE_
X-MS-Office365-Filtering-Correlation-Id: aeba4fda-4b9b-4437-6006-08df317a5886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|56012099006|11063799006|261009223027099003|261021121427099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: /Cd2UWgPfpzZkvN5oaCz3W4z08ALuq8XlmvD5hAkoTlb7Dr2AezW5EhejRN4Ohi0eHGpqQvFZWDSzqeKaT74BzuBBcwXADW7x+ePxRjcUL5s0wcOyxbfqTBJ5Ho4nSDGZD6wk6ICSgwxFzUZKoevaj6+S4jawKL2XtxOCUEVyB5fglbk165hSNya3kLg00MaCLfLLYk/Nmv2y1IZhGyz2p8NiNKI+hfY1QnuPkyHWwl8pF2Jnr+6hi5sJrNe3mj5OG3rEamTdMHYf6zP3jofWoBpTJ8cIpjAIWcXAI//6R0pySYNoJPcA9TKzykpS647XzxrjTJ2yLGinUJm92MeYcbLLrBnBFW2I/ctqulnClCPf46AkXaCiKF9ELXC5AzIDUDCDfGUlnn1YfFZHiS54e2sfJwG0tXbddYP86clmXCBoGc9Yf7t0Ffju13qkX6IrBmIjwx4hILTxw37FDfbBtDKY+Ufi7BH/bGMkeqheCkZQWcDQMRr+M7BWN3Gfkvl5l+4LAMT4T5x4bijVPQfrOzToJJvhbxE7vWTlpEob3V10ryaKgYDFOY+N1EYn2tfQTIc8jTw71Kqw8NuBG2iXe6eNC8dc2d4h/Uyg4A2961tnF6e5qMwjuOFfdr9vxwU02qiJMIvEyTIyMzXgM1hB5EOkhKmbm4JXOd4f+o6ciQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(56012099006)(11063799006)(261009223027099003)(261021121427099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SUXDRt27mfIcdbt7n3XHHSacPZdEypX9eNne7nf4hBN+IaD9/JjOdYchhF9+?=
 =?us-ascii?Q?9HIEtdY0WwlJtwO78Yso026ddE9p8R/4eSoO3cbLG9UmbF5jT+4vHZPi7WL9?=
 =?us-ascii?Q?UHBUdL3OxmgIR8RVQ6+sloL2ImFiAfmlvokkhtFEG+VhfX6nHBBeCYupNsJ2?=
 =?us-ascii?Q?eehlrQ9pDbuuD94ugkEs72xePdEMSMEalJ1tJIrxNZ76Hc2OfITQrtwWqfdS?=
 =?us-ascii?Q?E2mM4OnxhTlefg893F4/7Y1Mig1JNOIe7z8mP2GS+6wfmZvKdnkCDFKedWKJ?=
 =?us-ascii?Q?2avw0mnAAsK+gPA8pEqvLPBTwfvZEriziPwAuNEgTaawO3XmAnzwEmV+0EA6?=
 =?us-ascii?Q?vAm9Kiu7Gi83gwYf2A2pVX3r4kOfiD0KtGifr6G4IEytOnjITwtctowaseoA?=
 =?us-ascii?Q?QOEfYLonCdl/G2RcnQlHg585IfEtkLcLXZhkKLh1c8o8MT2aX+Y4h549ynYl?=
 =?us-ascii?Q?Ga464zyYiNpbnFVC08e4/nd8l75RU02msfEMgoa31HPqMEiTFpw3BDPJjO6G?=
 =?us-ascii?Q?SZ6lwnvvv/Dyf1N8zaUVx5IcIQR69PFMSS993ww774OClH0WQ9pH+b5MATum?=
 =?us-ascii?Q?NiF7fGCtox/MHINWjCWcQIGFcJoYwvINpIywk32ZN6j096BuLZZl0PapXAx9?=
 =?us-ascii?Q?ySU5JeLTEBfdIcXl485rsWxaEhhZWHNK2tvjKWUofdeMc+vXzcRorr8DgHUU?=
 =?us-ascii?Q?2KE68/jiCkv9FxSRip1veGTPvkXmTlDnSJk9JWbihWF0x/m0PwIz+M1CHMHT?=
 =?us-ascii?Q?yUl/mDSoUNOclysZhog0Q3zpiPiyEN/XhmMIviLrfoIfE1d5RWgmzJw+KDch?=
 =?us-ascii?Q?JMJ3puYv+y74moOf0jhlkum2IKrR5P4zq+CvuDiArjFtamC6dwYEtmwgLYa2?=
 =?us-ascii?Q?sDrpPizpidyd1t+FEUgQvvjs7kZ7Xlj4mNuWT1xV869+WEEThONUAmruicG/?=
 =?us-ascii?Q?SHFMcH22tND/rpzuej0ELewkJS45PeRMVgVtsk45FumGDJfS7963TOHKaS4P?=
 =?us-ascii?Q?cBNY76whVJQmfWnSpp9aGMwTmoGTkFoygKdek82HlSbxBntQZeHE22pTfx8o?=
 =?us-ascii?Q?837/0Xm9LPlgmw72KOqplo0GkFM+Aywp58w8kHeNvXKGQHqwdsiY1qipxWHM?=
 =?us-ascii?Q?7e8WL8t78x+o+2DSDN1ISSsknNi84m5hSqowNwzMibio6legtVu2AncFEfs0?=
 =?us-ascii?Q?Au4r3XUGeYqqPKMkczaQDASm92MfOQDhd+/jOcU1X8Z19yOvM5xHmebjnKbz?=
 =?us-ascii?Q?7DlhdyGZ50xAWITQX2OmDsR87UU/EgSXavKE87HGLDohIEAeT912mNje6o4L?=
 =?us-ascii?Q?QTISu4LUrsjUNSERunaqEFbZa69SIQNZAnNC+wTxehlx+SCAzACuKGap9473?=
 =?us-ascii?Q?uYk9Rf7IDESH8o4w6KyP4i/vc9vhyM5Hc7JrYdrD3Ki0D0WoKFJG8PpU6tAX?=
 =?us-ascii?Q?qe90fU3LzxPz5XodsNPyURIncpNTyDr6QT9kvKise6FhM5Hpa2EwOtN8ding?=
 =?us-ascii?Q?Cxbuwk8wnRccWDp5lPoiOG7B3yjdtEqwIN8RtMd8Qi8jPSAl/qW7uqQUv0V5?=
 =?us-ascii?Q?a7EjtBXPzSt6uXzpmr7zPmMzXT3vj0m/+4csKmBxmKa4ZMrgEriyKYXdFEwt?=
 =?us-ascii?Q?QcGyhT7+LLcPyV+uaEVQ0zUTbgMo4eQ1bx4ydzwJ2/w09sdobI74vQRGr8BN?=
 =?us-ascii?Q?elHSJJ3zjIcPpopFpTwK7yLIuwUlghk/VzcW+MBOxloRRDN3oGqMS9bBpqzT?=
 =?us-ascii?Q?npziW3joFYW1JLE/9LKImAnPmNik0qc=3D?=
X-Exchange-RoutingPolicyChecked: Ma50bqd3aNV5joHo2GeJ/K/P0W7AtU/OieOpbtjnCJjhI8looco0gNsBw3j+t/IjEnlGAVCL0I9z0aMVNmG79mH5s6tI6/r8VFGmhBbZ1KrOU+Ln9+G8rD704nJhcEW3FsEyBjfLXZmK4Tc54soiJOAPBCLqiopOjIxQG+LEb3v8XINVvbyG1HVPJAlphWMXSTm1J3jFrlUnm6SbvphZdLqtBEDxr1z1JVXHVFsV4hnNGqjSCfZ/y5A8cMCOaCCvQfpW1LN4dipcrTPTmk0KqKeXkWP1/5edXNdUjTwmnBzeSCNZ/4a061oawSbOxeMnwaZEFRNe5nzDl5+h6TfLIA==
X-MS-Exchange-CrossTenant-Network-Message-Id: aeba4fda-4b9b-4437-6006-08df317a5886
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 02:56:05.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Tv+nflvshEvZnOUo9iweeq9mjaG4qz8b0F0vHYLVQxXquE+2ASmVnSJiMLexAST6l2ijyK/6T1WTBsXxJHjBc32Fd8lozbsk0EkS31vPF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF2F49754B6
X-OriginatorOrg: intel.com

On Thu, Jul 30, 2026 at 06:55:19PM -0700, Alison Schofield wrote:
> A committed zero-sized HDM decoder reports size 0, so 'cxl list'
> renders it identically to an ordinary unconfigured decoder ("state":
> "disabled"). The locked attribute that distinguishes firmware-committed
> decoders is not included in the JSON output.
> 
> The library already reads the decoder's locked attribute and exports
> cxl_decoder_is_locked(); it was simply never emitted. Add a "locked"
> field to the decoder JSON, following the emit-only-when-true idiom used
> by the capability flags so existing output is unchanged for the common
> unlocked case.

Applied to pending for NDCTL v86
https://github.com/pmem/ndctl/commit/007acdd87f15


> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/json.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index a92548828582..2214f7027d91 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -870,6 +870,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  			json_object_object_add(jdecoder, "state", jobj);
>  	}
>  
> +	if (cxl_decoder_is_locked(decoder)) {
> +		jobj = json_object_new_boolean(true);
> +		if (jobj)
> +			json_object_object_add(jdecoder, "locked", jobj);
> +	}
> +
>  	if (cxl_port_is_endpoint(port)) {
>  		enum cxl_decoder_mode mode = cxl_decoder_get_mode(decoder);
>  
> -- 
> 2.37.3
> 
