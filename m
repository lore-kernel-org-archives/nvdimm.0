Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F346F376BF2
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 23:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416719; cv=fail; b=EKYyrjP+1LC3omx76I44l256BbbLEfIviF2eio10FzBHXM2W9ZHD2y6KFfoeY79U7pngvE7WxFwy7XXE2TBbTMHgM8wi9SUbWPSzxc+cNkqrkSHMNHDgMXP5Q2PmSxFazpMzIaLj2XQ8YGYx/35LK8i14qfNneUu8vosydz9flE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416719; c=relaxed/simple;
	bh=RPMeh8SV6ZdwMq98oSwCLfk+F8h3apPAft1+M6Y7GP0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hcSM7+sRAUUHL/c72zrOppJBUpfOKeDR7ck8NDqoHmxWONYCFOcUsfd6C+mxIzEA8ppYbYD59OAQBEfbq6E/UdvppiGBoFqXtDJ6Q8psLDW58zY0DuvW0lxs/BxUG+p/HsZQeBBOyao/GChqLcOrQhAEquZct+CrnGrVlIOIHeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P7VIh2lU; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P7VIh2lU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791416718; x=1822952718;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RPMeh8SV6ZdwMq98oSwCLfk+F8h3apPAft1+M6Y7GP0=;
  b=P7VIh2lUyFhiEX2yfUgVb/MDD8Du+28snX/MrMNUKIT9YvZoRYk1oG5z
   HNK/PkUB64GQaS57IGJlUWN4ysJahh7RVj9HASx2uiYwdlPR3gNTSVzgD
   PZaCJDiI+THZ8KKPNG95lidGsfHNQ3n+qNzrRxtNTccolGBMChaTaDNcb
   78wSbi1JpgTG7VB6m1KqMJWC0JIRLe6M+/4k3cGpL91F5XbJVyQBwrO0N
   Vp09inYUus6b7GY7j2Fxt5iL0KrMxbRhnVdP2BltScrhAuqLv65pA3qAy
   Al9MT2c6gF6qgvtR9YsdLCjV9vlNMhqFWt8Q7TshlV5iwJASubfy0hUZu
   Q==;
X-CSE-ConnectionGUID: 1VeqF9vTQWicn72vBn1U0g==
X-CSE-MsgGUID: VaSTNdbrRW6Dr5z8hP+PNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="94479"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="94479"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 16:45:18 -0700
X-CSE-ConnectionGUID: /nzPck5WRzKIdXwEZuKu1w==
X-CSE-MsgGUID: eNvEBfcAQUiRYBLlf66hCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="280791344"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 16:45:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:45:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 7 Oct 2026 16:45:16 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 16:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzAXkI+dupW+/Wua+dCND5TtSP70vhhPcykGN2tBlEIppo15XokkTsvDvAtVEok9yo8cQT152JyUUFRctysPplO3wOKuIRW8otTI7FBQmNXukcRQcuo71zMp4ruGMl6sjJbVYxZV/S44Q9uIoVmEdwu2nj7hyPUdhyLjgq8aje9a87poym9ncnVteqrkKApJy1SI3PM71fLC3fASOeMQLgql/bnEefylDs9dWkpdSY1VQNh+EHnc3IHqqeb4/xLhKcGusVy/YogfTp+QuMQHLOePkvKvOztijSzcBl7WXLKoqWBGqn6P7/LIn+LhQ1N4h7PEM/4Wy9XeekejEKtRBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QM3wUHSJRQcYTM5bRXkeY7vUOsfGwJ/p3GCp6WECcZ0=;
 b=dBUoajac/FNJh7857i6TDlfdijwLv+0PMUudr2IjskR7n7Yz3a+SgosaDed/i9ok+67nRRs9Om0Qlhk/V8kWiD3XVWaTt/1lQCvASlglouIeM+PLzAJc1+KFj+uJc1boZO1FSA4Soe0xKx/OvJomaG6f9g6HFrcQcsg91qBA7Cckcq1fB8PL7E7iDFAU+2GgaIVrBTM0cqTLx7RTdpZc4fqE9b/XTsqiQT/mvLdmeNOKJjdfJtSZlgPozLOJW320irpSeThZtxnytVZMRW9yt3Gt2W9+ZKdY8Qiadd/zvbsBoQYY02Um8zpuTiou4+SiQr9HF/x3t3BFws61hjjJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH0PR11MB7615.namprd11.prod.outlook.com (2603:10b6:510:26e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 23:45:14 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 23:45:14 +0000
Date: Wed, 7 Oct 2026 16:45:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dan Williams <djbw@kernel.org>, Dave Jiang
	<dave.jiang@intel.com>, Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
	<ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, "Anisa
 Su" <anisa.su@samsung.com>
Subject: Re: [PATCH v15 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <asbZhgPFj6TQEf79@aschofie-mobl2.lan>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-4-anisa.su@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261007201828.952-4-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::19) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH0PR11MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 83bad8d8-62c8-42d0-1c82-08df24cd0890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: dlp1afx4I0fGoQhMkVgtH6E3nuFjakCAxza0xrycmlCqOgUNUJcveTCcIg7cPL6vkPdPp4FnByW14sp/c/E+AKBgx1sn36XM1n6SRBvvhyZWhWuSIfPSzY0+H/KJI6OkB/gmdXWocewLZcSIYM+UoE8ZSCkxz9xN3YevliVdwWqdy7ocavf4GfflVgHw922OzhtgotHoFScZ6X7H1netbav2XTQ9MP/bywNJH+xZEV9AcSYarKVf/GZp+dtvJuYeoCb6cRFPBb7YHal3S93tu1QIpEN0KJI2F42kd4UU109SNFM1f/E8qXEEUXzOOVjWyngWnONaxgaEj1oPO90cO32g0vXXHDII5dJtopXBd+BpH9JpOelo2nssw5b/ZKhP1TvU84rK9E+hk5Pj6z9kig+jGWImENLuj0jxmxziNTtKQc7wXSP5j1GZ/CcjxDl18pU9ZTSWPYEAda1QzWM2M22mo6DCrxjZfUR5fO6Ae2/tpoNyo0hFzCViqb1MEJuamCGNwvtaPOZgVd1IXwTjc8UA98DQQztb7EQzBbn8BtCufbAH+191F+IvlNecjN6KHqR0jzuK/386FcSbNAGVJXYOMdJcj9HHVpigUleP76qfSm85AHeZp0JqXkuqU5LfQcelPIgf8t9HP2v5IlqJH5xmcaEentXdWk5Q2QaT1NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ESRHv1zxuulqFfzI9sRHtMfep/8KJxJOW64lyH7KRmXmm3FhvZm20bOUYzhU?=
 =?us-ascii?Q?hD/Cri+u1ZjpAdEYdzI/Kqb93J2X0tE5FWvCQ/U2LqcKQ7DoJVQctl9PiTpB?=
 =?us-ascii?Q?p0vL7EzqTo3xcVW/BhVZyZEa8ehP7eTsus4ZM2bFbvT7oQA4m8kI58iBtDZo?=
 =?us-ascii?Q?JIwvL0lv1lX+7sZGAxJvnF76R3885hZp0LeEwENWdHDO2Z+c70ju9bQWIN+s?=
 =?us-ascii?Q?AZQ12EluwkELCEVhwCbNesRPI3WjRsJWEXQA5fFSXLxxiU1hOo0t75gPlh0L?=
 =?us-ascii?Q?mKjgtNEWrv7VjlwmRGqafP03vOSXCz8ni/irdVLHX53JG/7U373UlE5eMinQ?=
 =?us-ascii?Q?6rBAuMLvER1sm6tZZzT5XOSDXosXrx/nhm588o+slCwKmH+nur9+WDFn1VMe?=
 =?us-ascii?Q?AwTYTIFBHI9ovsOwc5DVSmWhRWC3rTPDz++Gp2dQcFbRdn3TLH2+N1PRWYqQ?=
 =?us-ascii?Q?ZuUUSXkXZz3p3a6s+3ZRR/AYan21AXDQ/ra3yyDp9shqJFXldDs2zp6RV0lw?=
 =?us-ascii?Q?nWKi7/TifeTEyRnvH+uSLHaG2ZKO+Q75UAydDD5oeJTB99ZVK7QsoN80XObb?=
 =?us-ascii?Q?b8Eghmv3KX7az3xCFnfEtyHT8V4Ko+Y6ALnIeEBUkAmtFdQao+4a9va+BGZd?=
 =?us-ascii?Q?PH96iaHqi1pYJFM7O+HRER8y0XcDDoMS5rrR2t8OpKCCke/5sJf0gMZ7UAEY?=
 =?us-ascii?Q?aGYj0vxRokW6y4T3y/pcjHvhtVdnzFQVYWOHdIp9UgkiAkNe+iZF5cwwtK7C?=
 =?us-ascii?Q?x0enp02LvP5CFftG+VSAqQjSyy4N2MJkufsL5RBIrBM3JluxEwmwiNT9q42u?=
 =?us-ascii?Q?ST5qsAwvQbLSJzr2Z20/XySvcc2UUqWrVYXMQrpyd17CBMQGgj4hF5JLATo3?=
 =?us-ascii?Q?OpIK7AZcyNcCO3UvfJ9UrEbAS2bYfGYO/01DDttV8mf9yaYgInm6paKuft20?=
 =?us-ascii?Q?nJJlDQphazFUg9nF3ysyb19GokWrMcyMcXv0Aa72A+jvKxXFRj/isHA9yeMo?=
 =?us-ascii?Q?Ncjx8w5AyqUJYvivPNsQ/sGyAkpe+QsZBVKez/ozEqvnh8sgfiXtL0yHg6nU?=
 =?us-ascii?Q?QELo0aJ6fRrscDPpv33QYEJpZyeyGfQMq+oDHf8LAhTUOrbkaDOpaSZFRE1V?=
 =?us-ascii?Q?/I3SNX5rhb+GIQjwibVa7SBcf1q9ObevtOB5HJE7IcFoE9ZZ0fHQH6aSikVT?=
 =?us-ascii?Q?hT7cDEh6EjcCDyQmPXVB8NjKCbfd7ieT4GA71oPmPxcWZPVH1f1rU3i98bQD?=
 =?us-ascii?Q?feaXT2z92HdbqULFsdXjPxmAHIOlfz30y+rZnOw/XCCWBRgWKgSQgDcs/Hd1?=
 =?us-ascii?Q?xB4Pb26CaWBpb0jV6GyXI4Ldns7yzOkOCwGWhr+UcsKZZpWAbGgFHo4jmKa+?=
 =?us-ascii?Q?EIaPArKhya/a8I1CsUdk3WqDMsd/VJT2Q0wUJJcR2U9lRX77NpceFhPTWvsb?=
 =?us-ascii?Q?XHkiRiIHzyOgJpr5CJWFpM4ahdLalPdMUwmqNlizABCGPLL65vbXPP+L/pgn?=
 =?us-ascii?Q?bRKUnU4kvY+rSb6gjJ1UOeU/thheRy64ItCHs4jTvi7yTgIhjMSptvhUOKqx?=
 =?us-ascii?Q?YoTLH047RAiZQI34Sy5fEKgFjv+wiJhAmNaHTxVcBcRVws3zrMPFXdR4k+v3?=
 =?us-ascii?Q?lwVo89gOxFjGBvYZ3J5O+euskvIpxAJfr2Ni7mojXnI38YowWNQri5QN+ESA?=
 =?us-ascii?Q?otl7L1+6n/P0WixeY5BEkCkO7CnHpscU/5g+GviuQEoE4r+78LeRWZ4hDvXZ?=
 =?us-ascii?Q?dfnrrNjnX1Q2rqw98aE4PlLmF67nZ24=3D?=
X-Exchange-RoutingPolicyChecked: ATlEU7aDZxdHr5ax/Eeb5O/d2nq3uH+RHaiMlkwOiAVQFnJzG7nk8oc3m/pZB9LKYXMPnGsqp1bgmYrLg85mlV1SIl2snXou4pTdGd5leROL6kUb8itfP2lcHBTPPvSeiVaZKtgK36Jnit0MbddyKDEgYJezb1y4AFXyQ/x1Rhi0GKdy6JBT5q7yg34q6tZXuV9G8lzzHNnnI7Ty8pkcoGCPDkFAk+IivAuTg5fCB+62gYzOm3TLpaHaKS732BcbzCprZmwNK2+6Ewl/HvE6Inawa5RihJsJc5Dr3hRI9jPQQ2f5OWtfjsxCsNpgcgZ76UhL3U6kAdBOr8aw++qB/w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bad8d8-62c8-42d0-1c82-08df24cd0890
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 23:45:14.2019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggNdr5cwaB4LEjxHo8rtswy4D5haSQ9/OWojEeOJ/OfmxnR1b2MH7aGLV+2kOxLwitmjlbgqxhnXBAEdygJurX8TJUfqzfvNJHtoSgxfqJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7615
X-OriginatorOrg: intel.com

On Wed, Oct 07, 2026 at 01:16:36PM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, shareable and read-only
> attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data. A DCD
> shall describe its DC partition in a DSMAS entry (CXL r4.0 9.13.3), so
> if the CDAT is absent, fails to parse, or has no entry matching the DC
> partition, disable DCD rather than run with unknown attributes.
> 
> DSLBIS is optional, but cxl_cdat_endpoint_process() treated zero DSLBIS
> entries as a parse failure, which would now disable DCD on a device with
> a valid DSMAS. Accept an empty DSLBIS, and skip DSMAS entries with no
> DSLBIS coordinates.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

