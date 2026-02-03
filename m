Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBE123EAAD
	for <nvdimm@lists.linux.dev>; Tue,  3 Feb 2026 01:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770082332; cv=fail; b=dY4EtIfA/0t2XOArMxBHrIfS0k77KPjVDN7CgWfi9nzWSEVdYUs0Yd5ctH3UY4qj1CmzSFZMYJW9AaSge+zVN8mB6XP77V4+faOAd+QqqiGTpiDdQEhdhlQYy8IyxJCnNpQUpsjW8biUx/sW4YFy7BgDdqktDSr+T4SJ8QdDwwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770082332; c=relaxed/simple;
	bh=ZxFD4VXv5peg+4NCqwEes7M+DWHDrhs4PpiizKc4EmY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z7FyqTB74AtDDWV4T350wm5bTnL8ZGrCuGeij+SMrzodYei9Ulcfa0bYwg9mGocVGzL68kgcDLCSEagK4tIpPwD2Zl8kjMO/Na256nxQ90Ze6dG5AAjJBykoFXQ0n65ySmK5HBb/L+qseq7kewtebBhl8bhYSRedqHLfepofxf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g7M6kbRf; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g7M6kbRf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770082331; x=1801618331;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ZxFD4VXv5peg+4NCqwEes7M+DWHDrhs4PpiizKc4EmY=;
  b=g7M6kbRfa0zQ6kPrOG4C2VKVqzvkl7zm1v+52roB37IY7D8CDt0ZMiID
   6siV6RTBJnHcIgvNNNlHidua/6qrTPJDu0l/PdeL0vsTxyFHGC8C7fJmX
   W2wEK3pFYJMQ237M6yIsZM8Wu9n4JBrdMxJJxGch+RYHfILMAkheN4urE
   nHQ+cGneTBfpQ9PdV8fz+Eda3iEuABTnbvd6h7xZbM4+1yXKf7dENyAZj
   X2L6h41DzbJ23Ba0c6D+482/Aqj3ru+sNeMh26BS3YykBm4BQZ3fG8bJX
   2X9azzH5VFQBn8PziEKV+sqzo/lm3yTJKf/zo9EObrLEei+gi34fuZKyX
   A==;
X-CSE-ConnectionGUID: o3FYtvN3TEic3UhjjMzxow==
X-CSE-MsgGUID: BMWIydEhTPyAjuLURt+EsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71149075"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="71149075"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 17:32:11 -0800
X-CSE-ConnectionGUID: IRMLh11wTLCd5u0ieRvCRA==
X-CSE-MsgGUID: Yx7Dw9I5RHqCnHT06xLeMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="240735537"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 17:32:11 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 17:32:10 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 2 Feb 2026 17:32:10 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.37) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 2 Feb 2026 17:32:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXE+ApMOxbHNXHwJGJKGIxeoMeEoXrohJ8jFrWGz5x+TvwipGoipSgdz0SinbdZKJ6oP9NGm06WxT1HhLLZaElalfX/g4Oe5klkremGAChB80BGSnVxVDQBiAdL5t6sTF5wO2QzxDaidq7mPPghOmz6RWHWaJR1PMWsIOEo0P0Z4Sy5Uprlw/9p6AMTspym16M+szhBZ+V0nBpUC9hio+UiCqp6Nj0fnazTKFCAUoC8Tq51uaLAV4iwK34xsia9mil2qkGq4hB/0RQ3DO8DhF44bkdZiHxLjUd3rRbijN2WcAcLnaxCHj46JCDaEhZNB+gEa09MU3v6myYuAfNFhvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDNmtr52AucihnID3lUi815i4alzrFXOzvDQHE0ba+4=;
 b=oDTSgE8OVwpYxW9YvEN8UErrLMCbvr7/xvQhkx+2rwfyZnInnPMUddrAyjM9V75Ahp8zPJnilVDSiTsUtn3D6gb5hQT36ZW9ka1/ZxjSHU+OaJcfSPuJw/SUEjquerMkDWOH92b4LkvO3HuL09z4RUUDR9+xl60pX+f21b1uWOEl0X9hAmHqn/XZbXYQzz3NTXu+usVLRfhyALb51A9BIbHBpAayc2cAGcYOgMqgeXkCgi1c4QgHWrXXY/qT8VDs3iHOyqtVdxH5h3TS+8rjd+MOgyL6trDpfQPk1R2/iGKjSm2O+hvRRDJQPHTr05h7liNCy4Ni5x6aJFjd9LwfeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM3PPF9D56E7727.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 01:32:02 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%8]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 01:32:02 +0000
Date: Mon, 2 Feb 2026 17:31:55 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
Message-ID: <aYFQC8MbINsbcDrU@aschofie-mobl2.lan>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
 <20260122203728.622-8-Benjamin.Cheatham@amd.com>
 <4e3cf71a568f98a8349416874a7f08a5e5099799.camel@intel.com>
 <dead69ac-86ee-46ff-ab38-c964935cda13@amd.com>
 <34210a8339035800430a9d4084154e17c285ee86.camel@intel.com>
 <ff553d4a-a1cd-4d23-b0a2-baf4d7aa72a6@amd.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff553d4a-a1cd-4d23-b0a2-baf4d7aa72a6@amd.com>
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM3PPF9D56E7727:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7cc116-9ca7-4d29-9e28-08de62c40839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?F28zytY5PvHdBRy0oM43g7sWqbT4Sst0XBBxXq76nKdYNAEc0fWaw1c0wD?=
 =?iso-8859-1?Q?wnhc2VhyRrhULkHUvwiuUvO7/j//wag6pv78ZtvUqL7lRjAXCE2TULyAjM?=
 =?iso-8859-1?Q?sQkJFa8K9Tqz95OGwMpKTZkgnEvTN7TsF1rXeMJg0kwVDElRebIubSfCcW?=
 =?iso-8859-1?Q?9LtGjVLubD8L+nHJjckGVi90wKceE4apuZJ49d8I++XYxkPCXjg6d9Prtp?=
 =?iso-8859-1?Q?KQgABF40ET6r9wEpqnRIQooCFNd15m93BdB8Q2PM5jjdhdk1tCsbp09BMW?=
 =?iso-8859-1?Q?BS5anx1nzK4cxatGYyc+sh7ONYeVjoFE+I3mZ71sIFZfkgYu7mHybZ5fho?=
 =?iso-8859-1?Q?WhHsnP6A8qyfxlhv8L2Lr51Xf43I327dbln5/TzKpV711KWeWwFy2qX3d3?=
 =?iso-8859-1?Q?W/Wwo2iNDTLh9GOY2TJxGYlHTzF2P7EJNIrm/8kjCCChMCJBN0grLbyxG3?=
 =?iso-8859-1?Q?QsYLKOT+qQfOawjblW3m4gxchudUqp2BMQDE8OcFiAF7UdoZe/7gCLDjMn?=
 =?iso-8859-1?Q?4di+rAQTSAogoYHbCbq0VAZ/hfBoH8xp320EFCStORKaz/f+DqacGnfxay?=
 =?iso-8859-1?Q?s1YS7GaK6NDRp2TasWireNNBfg7Mlrbl9uJP2hzPlObVLFDM2lLMothJvO?=
 =?iso-8859-1?Q?RsvJyZeRKSgnKDeahMtX/yh/33nX5GhV54NISOhkMWRw3b5b4godln+kvU?=
 =?iso-8859-1?Q?E8DgxZGlsRfTl1GWPLFMmssKV7Akyae67LoMD6E7RksQBq+QvSDsuvbrch?=
 =?iso-8859-1?Q?aZaNLfddrx+sO9iBqkJ9w4dj+Xx80ze4CfUlncKfegB0ERBLgcrZW/6lbo?=
 =?iso-8859-1?Q?s9iBNSzAyt7SwSghD+hI9UYSJm5jk5ZozCMIyF7V0Zp5c+AgG6FfHgrpk3?=
 =?iso-8859-1?Q?b+A4yGpfvNmpe8cYEA4nbLh+aAvFOo6OH3sQ3wiZunJP+ikkB03UVnGnRM?=
 =?iso-8859-1?Q?9QuM/pRJolGoxbLnjjt1rxiI4fdZIqwh7kFHNgegxKCxVnVIe1rpKRXJwM?=
 =?iso-8859-1?Q?hK8ngZqExyLq7iYkgYQmPuIR+d+KmwFHe0UvkgGovS7RnteHxz8/m7KafI?=
 =?iso-8859-1?Q?/L4iwafnEyHArtgfRnM6t6deB75xAEx0Lc71/0k6BArinyRPrdr3IgZ7/A?=
 =?iso-8859-1?Q?Heh2ILTylC0livgORoo2KZ5M0Q+ST8J5Rz6BG/pGpBElJsJEHXLcpDe56c?=
 =?iso-8859-1?Q?HvhA6oOaNwg1/BWr+sLLPTH5k5LF760+xcGAS+yzmBDQe2IrmTJf8EfYja?=
 =?iso-8859-1?Q?9Dc8wXvEpSMl+ZBCkfwBqk8AUsLBYgyEc8gt6L14cMkEmCDNOQn4I6LuM2?=
 =?iso-8859-1?Q?w+44j1SXqKm5z/vzY49091T4qoN76hxce1BPJbIFrWo1cei07WXdMPPJdX?=
 =?iso-8859-1?Q?1G6yKU3X603ejid5FbcjqK2eOTwiA+skWxD4jSgEWIv2GybwZ3NBS9qqQI?=
 =?iso-8859-1?Q?Qu31qdeGoxGxBWHfbra2YnD3mOnImwkWBIwr4MZvXhyH1OJuOP7dNTCNT4?=
 =?iso-8859-1?Q?lloyRkY9Vhu1aYeLwH0SfpWB/FIb159KmMhiSGk5Zw85T9Xd+FGVZ1FL8j?=
 =?iso-8859-1?Q?8oOxC/DAnciNvzgz/gkDWWDME3Y6wufxXTRHmvRfAN+44iYogg7wywJQ/A?=
 =?iso-8859-1?Q?e9PGnopJUS8xY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?IbnirrDuxXbXj9Pziw73NJFLyYDjPByTEvA/+oNZ42z5intBliIKPie2aR?=
 =?iso-8859-1?Q?MG//rnQwYgijTodA+ELcIb8jmm8VS0yXazYDagsBqjzUXTzeGqlHRnZMkz?=
 =?iso-8859-1?Q?PQ9EaS4nY+qs2aIdmX9izJ72k35whGyi5MEER0TOs6sHzSgnSqiD3z6YiC?=
 =?iso-8859-1?Q?LY64GsRo60HRGAC0WXBGKYZXNoT7jtQhazW24sh9azPAU2AkCx/+meFB9/?=
 =?iso-8859-1?Q?VxWbZ6npUGm5++wbx5DaBx+lAyvL89Qra5/+EnA0LMOma2gmWNAwAitJjK?=
 =?iso-8859-1?Q?X5vXpw4BEuhzqE+nieEDqt6k9V5M738vctUNu88qvq66D6Ub1K+ppEAQ3a?=
 =?iso-8859-1?Q?+jXuLTM1EzujdNfRIlmB+xpKNMdg974t3hwNirmUB0RZX1gr2Is8ESgk6h?=
 =?iso-8859-1?Q?oBLPpg8VYNeEXkPPYX0OyYEMKtFw3wj8BIiisWgNsn9GzUc/DgMJGq8YVc?=
 =?iso-8859-1?Q?uMcplPnR7vBICyrNaP8k0Um51DXH5fc+SaImPCNmh2LNaeZG1dR8AAM/j1?=
 =?iso-8859-1?Q?8nfmElHQPzmUkQwje/Q7CVvD7ivMOMlMqXDXHS9xlQzwqjcTuZj1DCASJC?=
 =?iso-8859-1?Q?4DWyu6U3UjCC2GWWEG6FA/ch/Zt3GZdnAPfr7KO90TXcNkRP9cefMklHCS?=
 =?iso-8859-1?Q?XidJLembwArB5y5dObQG2oM8d1Cp2ocDSmeeIEpo0mMZiKHZB5z5jFlnOK?=
 =?iso-8859-1?Q?QOLFvKI23MaRHJNiXfr2X55RnSySvrpzkNd/JA3Ksj8xhqylNz7rDkMcmt?=
 =?iso-8859-1?Q?k9Du1z8zced6fYeLZiJAdpgYMIJLmdTqYbFcPvBZ+dTXEEeB2/fSNscnbu?=
 =?iso-8859-1?Q?U50YBnObCnJeKxhxVQzMGiujFRCS421efBc41oDjRQb8PN8q+MR3Qpc4XK?=
 =?iso-8859-1?Q?JQKadgus5WgWjlrY2iqtMGu/MLTiyQzCEvgx0rXlN/E0gAWqptGrv2Zlbp?=
 =?iso-8859-1?Q?qs0YkbjsH9nT0AOP00bGxZqXociZezR91iu7KGEE8XZJwlv8yDq9WOvMTn?=
 =?iso-8859-1?Q?TozzZj8vaGrDZyJKDLlLIOXhORsb0YKyEIWplEiQi/zt1XsYR+5W2m1E1z?=
 =?iso-8859-1?Q?ywsBrhNICq1nsF4n3mq3Lu4pBydcRvwRrnOZlUbIamSo6y2n63u00vSnay?=
 =?iso-8859-1?Q?2SvZPl4Kgf/A8hk6RXXBrUpMpraM/Y6zNOfzVzm/2XIDZIEctHc/I/iTWp?=
 =?iso-8859-1?Q?BtFBYezwAqFgcKLst35DOn6lreKmlJSPL9RqqrNPVych7CNkO4w/ksAytN?=
 =?iso-8859-1?Q?mszpsBiV1b5nQ5TnD+lWNTfi/l+9DWYpuoDZGv2WoSg/B4qNTNc+Pd3x8l?=
 =?iso-8859-1?Q?G2Z/LV558urryHmdapVMAxqhFmnxXMGajVcH7IzG0KKvbJdWLHa5kmQgT6?=
 =?iso-8859-1?Q?4uvD4FQE83yvtMIzb1CIhxaVVJIMAax8BtzoC63B8hx3Ud0ipVxKhlRBHQ?=
 =?iso-8859-1?Q?a8dsjp3QGTjhpouOkE8Cqj5fGuq7bznKmhoDq7bAy2JONaMCnp93aXGc9N?=
 =?iso-8859-1?Q?BFKTUb+vJ9zcpgIPdJUtUtwVxpY6lhBjbSuuFVOdEXSk5wJVLD7KN2Xmrn?=
 =?iso-8859-1?Q?RH3v8vNrUfUVLvPqfwwhhZfVqvTNOrnDBQgfJe0I5aXydXNu6dQbgvJuml?=
 =?iso-8859-1?Q?ylg0ms5C9s5gxjmi4a+Y1mslVfTHVSCJc50tYO+iutzytek1XJNpvvlm9k?=
 =?iso-8859-1?Q?uBh8VIKdPKJRCmbTSUb7/QFMWRdpY2kbLSSGAuQCJzfHYYsuE6ds/Jtlum?=
 =?iso-8859-1?Q?L3lDbhQz+w8qdoQ5JF1Lk+mgrItxGMTAoabrBaELogUftv+o+KQOaiL42k?=
 =?iso-8859-1?Q?aPSnvxZ+apfo7Lzu9E17j62VNK/RxnQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7cc116-9ca7-4d29-9e28-08de62c40839
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 01:32:02.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FfxkBrHGXtLj7lDSC4CPl4CnVhJCsQLQFmmoEem71nkOdn9hc6KPUvxmW1rK7bXoT59jVgpwgR3AkKZ3H1JydDzU/q9Q+tLcjabASYTraU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF9D56E7727
X-OriginatorOrg: intel.com

On Fri, Jan 30, 2026 at 03:45:09PM -0600, Cheatham, Benjamin wrote:
> On 1/30/2026 2:58 PM, Verma, Vishal L wrote:
> > On Fri, 2026-01-30 at 13:59 -0600, Cheatham, Benjamin wrote:
> >>>
> >>> It feels to me like the two injection 'modes' should really be two
> >>> separate commands, especially since they act on different classes of
> >>> targets.
> >>>
> >>> So essentially, split both the injection and clear commands into:
> >>>
> >>> inject-protocol-error
> >>> inject-media-error
> >>> clear-protocol-error
> >>> clear-media-error.
> >>
> >> This seems reasonable but I should clarify it would only be 3 commands,
> >> clear-protocol-error wouldn't be a thing since there's only an injection
> >> action for protocol errors.
> > 
> > Ah I see, makes sense on 3 commands. I assume the clear command would
> > still be clear-media-error for symmetry.
> > 
> >>
> >> Should I keep this all in one file or split into two separate files
> >> on protocol/media error lines? Could also do inject/clear files if that
> >> seems more logical.
> > 
> > For the code - a single inject.c file probably seems fine. There's
> > precedent of implementing multiple related commands in one file, and it
> > makes sense to me here.
> 
> Ok, sounds good.
> 
> > 
> >>>
> >>> That way the target operands for them are well defined - i.e. port
> >>> objects for protocol errors and memdevs for media errors.
> >>>
> >>>
> >>> Another thing - and I'm not too attached to either way for this -
> >>>
> >>> The -t 'long-string' feels a bit awkward. Could it be split into
> >>> something like:
> >>>
> >>>   --target={mem,cache} --type={correctable,uncorrectable,fatal}
> >>>
> >>> And then 'compose' the actual thing being injected from those options?
> >>> Or is that unnecessary gymnastics?
> >>>
> >>
> >> No, I like that idea. I do think the argument names could be better though.
> >> What about:
> >>
> >> 	# inject-protocol-error <port> --protocol={mem,cache} --severity={correctable,uncorrectable,fatal}
> >>
> >> with the short flags for --protocol and --severity being -p and -s, respectively?
> > 
> > Yes, I like those better!
> > 
> >>
> >> For inject/clear-media-error it could stay as-is, i.e.:
> >>
> >> 	# inject-media-error <memdev> -t={poison} -a=<device physical address>
> >>
> >> or I could update it to be something like:
> >>
> >> 	# inject-media-error <memdev> --poison -a=<device physical address>
> > 
> > Either of those seems reasonable to me. What's the possibility of a
> > /lot/ of types getting added? Probably small? If so, maybe --poison is
> > cleanest, no string parsing needed.
> 
> I'm not sure, but I doubt it's many. I'll look into it and if it's less than ~5 or
> so I'll change it to --poison.

I too like separating the commands. Before we wrap this one up,
here's another flavor to consider:

inject-media-poison
clear-media-poison

There is not another type, nor a placeholder for another type in CXL
spec. The media-errors are poison only. The only variability is in 
the error source.

If we do 'inject-media-poison' today, and then another inject type comes
along, we can always do 'inject-media-blah'

Maybe I'm missing where the other -t choice might appear?

-- Alison

> 
> Thanks,
> Ben
