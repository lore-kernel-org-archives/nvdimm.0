Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569E92C0F84
	for <nvdimm@lists.linux.dev>; Wed, 21 Jan 2026 00:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956149; cv=fail; b=pKAayT7uv5gT9u5V+bYa647+uowCtvJXmHLrzUG5OiyM7rNWj5KoMuGgdItUY1uOXLz5z6AGzZANyJxX0ur8qGMVgaFT+1jkYJTjy1PiGqiix+1aHOWQFXU5afkIKijU+WkG1torx4snC36js2swu+1BFyzekiyA7Ajyzh3Iw4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956149; c=relaxed/simple;
	bh=FL5gpGCX9nIA8v0je8E0/nvXbMmf6SIXmgp1+3t7PM4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bV6sUARSLcAkiSX2HOeYvGAwDnCfnM4MFYlvaKmJYXvDA13EvvC8PHMyf+Ve4NDUwhFxzPVAFfHU6cyQsDStmrRT8IL8Sg/TyYTEaei7x5k36t1knvjXUqMvfR8N/fmiHnJ6RnHodxMWevdhe4Q1hlNmLXBnGy6iiAPxE1JBqII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2hn1WxP; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2hn1WxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768956149; x=1800492149;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FL5gpGCX9nIA8v0je8E0/nvXbMmf6SIXmgp1+3t7PM4=;
  b=a2hn1WxPOjg7/Dbey5L1F0LVntv4/U7mcbLbHUkU1EfcSpQG1W5eP+Na
   7D+ovLV5+hqRCmWZIIwbs3ERSDj/PwUtEtYiOua4tiPViOCAwuyrpeH1Y
   AqqySqUiIsgFRQtj18BD7hW3KeunSPSCUSfIb1XOmO3F9c1UDjVg1UjXA
   +d68nbXgOnrwH6Bfm6OzTUp7XIYjtjXGZnHkYrMYr35iCGr5jFceKvqRr
   rp2s3ilOV/s18sfTNkQAjcGmTk+8StC76Y5ipggz4i0adUPnD8MsueTO6
   JHMyiKTnGdc7v9qpPt1cFJrEUoewt12tVF1yX/p9OkaLWalli9rO1PTfS
   Q==;
X-CSE-ConnectionGUID: VU+aZMT1TQ2jE67MCP8hlg==
X-CSE-MsgGUID: UeVDU92PRMmofCK8R3fwcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="70151610"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="70151610"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:42:28 -0800
X-CSE-ConnectionGUID: dITlTblRRGCgLiuDUu3y6Q==
X-CSE-MsgGUID: alNY4V4nSGSB18nsvp4yww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="205407869"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:42:28 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:42:14 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:42:14 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.19) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:42:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hc1x5O0H8K36aY8Nrxx+RAU93hNEYEWTiiFO47tMnGQYhK0/fDN73OU2q1ah2HsszpO/A7g9Ot6wjbcqfwwqlkPpSiTiduak9CJOamsQ5434VfJ2G2z9Fghvrc/cnm+cKDxjBKXaE7UvRTut0BtxykMa0/IMe+VFEuS1WgnxPA0WUqxjbeKZGYU5iV4b4t8rAsKwnar9r5On0JfmrHF5XnOcfqm22fsp0x3yuZ6GNdSwtEh2ICjKmY5HNdKqVlCXy0kB16qW3jD5GsEBy3hXStFHC9HHjC4MCLkZgeatafBeYgw4vXJ9aEPY5qZiLAGpW3x2OqbBbiYx02GuU56MdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrrzuRgUM4FwvMJ9rlQp68nC2eL5ID+P/NTHsiBhdqM=;
 b=PIbHR8e1+3vtwHd5rTMR7XbPsmuwumHK4vW2SHxR9YzEb8vejc5dcOien4b+I8y82N6iWuylOEmTh3ILSuhEKTBIGqGW4Qx1wqQuTDm3dfaWwCTinXgepw3USvRFpgP6qKbi7oAXIUYdIEUbcUySS5ROQrnTAIh9h9xNiK7sHK+Q7Xdy5tNug/h3e0QGhbwpXK/OXHuPXus6QLR/zZJ6sfHOaCdg79lU/jrElKQpAJFyJ+F1juqIXhVPb0i59OzBWxOBSrwd0vqiXR64vOakQTu8f0RS/czzyKpctxy+QquJdKiK09LPp3ZLd3khPiEEN+NdnyKxzelI/A/AflRzrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 00:41:58 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:41:57 +0000
Date: Tue, 20 Jan 2026 18:45:08 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V5 08/17] nvdimm/label: Preserve cxl region information
 from region label
Message-ID: <697021942837e_1a50d4100c8@iweiny-mobl.notmuch>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124521epcas5p299cea0eaef023816e18f5fd32d053224@epcas5p2.samsung.com>
 <20260109124437.4025893-9-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109124437.4025893-9-s.neeraj@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DS0PR11MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a284b8b-1112-40ba-0f82-08de5885e185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cAQq3vveqENPryhV8T7+QI15FRLXEASoBqaPuq1dsjzbORaZclLSc/mqpEx3?=
 =?us-ascii?Q?3b2uZ29HbBceApBNcnsLH/nPf8z9wVFYoiQSnk2mopmbnKst/wg2C723fUdm?=
 =?us-ascii?Q?RdkvfGnDitgFO0Wpe3LOAmU0taulo7wL72qx///we7G8KNdoTtQA5Jda5xS5?=
 =?us-ascii?Q?OekmWVvbP86dXJ4jyepSfkjgj7WFjBUGZXpO/zt+xLv/TO1ccBz5AziBf6yt?=
 =?us-ascii?Q?6T2G6LW5pJUT0yeW25xco3KVEiYqRYlycWYn+0GAqWzlrZMNMUEAoDBBJM/l?=
 =?us-ascii?Q?qCPC12hf08OFTgaztG6WdWk3EwLv4exRF8uhSuAEfcnnpH0pFhWLJa3f+A7X?=
 =?us-ascii?Q?BFPhIANJsm7m48ZLgGvvzHOLXQ85iG0gOzs7V2pTvZJZNmIJsd1L3U/SGNhI?=
 =?us-ascii?Q?hejrK6A6BdDpCZh81bLjQJTtxn3P5TNHXqW9mjv2vaePMzZWcnj9vDkElE6X?=
 =?us-ascii?Q?iyk33+UJC7h1HTOYgI4tzI1nl7WkgUcKr7R+1w64+g2tFl9uREW6BdcZgC14?=
 =?us-ascii?Q?gXRa12h+5MKlpNjt1jaNbbcti4YUjGKtJcnX6iG2MuKrGvthqBLuu3kWtQq0?=
 =?us-ascii?Q?AO1cuP6YPT+ndGN6zvY4c55w9UC68P5YrgfPXp4wA4I+5r1BftVmDkwoBA0n?=
 =?us-ascii?Q?nVNLCUqEizg4CClFlpXnNt6zUYKs8o0dEeUNIOK6KaddDv7vuB5sCERsfDzF?=
 =?us-ascii?Q?slEc3nF2iBETf08wXXWPB0b0igWN/thcMLQq98OkUliNQIAqpm0i92yUCMI5?=
 =?us-ascii?Q?vRz8CGZ6Y95CNNK3+4QmVcZPeik1EbujzNF7ZC+WuS2wPIoLYsQZMjSkkgU7?=
 =?us-ascii?Q?AE7+vuOEQyfAIUIG4cGImdg4WYh9hR0Zi9t/mXm5wqYQh2pu8Gn8+Lz3GyRN?=
 =?us-ascii?Q?IbJ3xcerF1TRhbElOXS+TNyYr6tQyqn94Dh3k8I25TmndDtT5YbIIZ9l8MEO?=
 =?us-ascii?Q?xQvufWOxwzNkrCL0R5BK++PaQgpfY6HhxhYIPDmJaeIpPhtzoJERA4MVs8WZ?=
 =?us-ascii?Q?2GSk9fX1ri1J3Y45L3lxxxULa28xNllDDgjPoP+ggQ/M0R0s8+oZHy4G6cyG?=
 =?us-ascii?Q?u6lDrjVawpHNRBvEJok3gzeTCgxaMq2usIrzQ9YaJiw0f9AeWXaTiC+T9EeJ?=
 =?us-ascii?Q?MugWDf5z/mD+oOezYNwKmz8SMaVFVdnKo/niEbTQhy9o/32K6JJOJ1B2RBO7?=
 =?us-ascii?Q?J1tW6BBln+L5xzBCspaGGYX4IJRv5FfWiSSYG+A96/fm6KvA46d0+CQZowwu?=
 =?us-ascii?Q?3W46mDs2lRh2AIPlCL6LbzxKHuWhil3zm4G3UfuAKhtKCDqGY5Qxn4BITOAE?=
 =?us-ascii?Q?7Nf1/upTIxnf3iEQ9VPKdjmVSWU/yyRtzQZ/R/bZR5WvX6zS3DaiU9U/Dyl0?=
 =?us-ascii?Q?M2A64abpqNPsyYMR9DuIDbr4CIKga95bx0P3KMkdRv1l15LeSpfSM/ZQK2j4?=
 =?us-ascii?Q?l0sVhGBoUZ2hb7aGiPwj8l4iPxujWgdAPW+yVLiTFCKNk2r/fZNita5Eo9ES?=
 =?us-ascii?Q?CS3AG7hL13PIP/jJ0ErJzsdR1T+08Qptqc9kfBc6wvfFbaCfZWWxOxQEVnR4?=
 =?us-ascii?Q?i3OGSYIjVJq4vbmavbo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?br6XYwSjiu3h4AEXaaX4GW5b7tJsTxQPww8sXXFhxs5nE8AKa+aJlDJvFtTL?=
 =?us-ascii?Q?Bio9rqF0VmLGx1TmOx15rnDZTUHkkWuj+Sr+7PPHBXGfJ0+iFmrgTooQO0Mb?=
 =?us-ascii?Q?8c04SdH5rYN25v5Ou4tzfH1Sxwz6q/HR0IHhqDmvJPKw4T1HmpKm6IrqmG2S?=
 =?us-ascii?Q?0Ini2N3fqoQKovvBsXILoD8urruPV5jsDoaUa4QXBA9zqQlUqhe4lcFiu+Kx?=
 =?us-ascii?Q?ALvLKStF5p/Zgp+g92py4/1thcIVspL/E0Qhq+PGGm0U9o3y6jbJiUUXZo1n?=
 =?us-ascii?Q?2t33iwxshwvbiqkz9D+Lp6mDSVFS8MMTZSbHWN35LM9eR1mIEMVz04jXGjwj?=
 =?us-ascii?Q?onrAScvCGf8cyXEWO2GuzWWesnPMnXCQYOpW4rpzq020dfjdsqL4m64UScxK?=
 =?us-ascii?Q?4PztU4D7LQsUoNVJ+6OkK5B1jxJML9vFM340TP4GqUzoDhBb2ULjo7/QQomO?=
 =?us-ascii?Q?2ypGYWsRflKFXmXJaxZ7joa7TbkC7fMts4KzjDRajxNmPP+3X2N/CxfyGgXM?=
 =?us-ascii?Q?sAYGFwzCoQwhX5Yo0jB5zYvd9K2LqYDDyxvXwluXL3D6DOgNwDcrvVYrb8ya?=
 =?us-ascii?Q?PJi2kn3kdGqef95WwoRXh1gB5iJDmgAg3+nW8BPJZFTDySHpLR0FqxOyjqzO?=
 =?us-ascii?Q?kgCN2zo6TBR5s2GmOmlB1SrNUGCrMiJPrMI+MG4kjtyPebKI5qg5oWV4j0/7?=
 =?us-ascii?Q?mmB9pOZXZlAZWGODkykcSTcWdYboE+nK2/vwBQkKvUIVG6LmDbbT5tOckadE?=
 =?us-ascii?Q?TLFrWP8BGyjZWRlYvPe4oonL0TuPmbxS2EIiluQsHFF7J038Kz+KNOuYqA/E?=
 =?us-ascii?Q?9LsFJU9F8dh7jCK4Tv6KLr8SS/1K6rZUYszuTydMKSbKs2UvRzEj6RqG+i+o?=
 =?us-ascii?Q?0Ffz1UWubbfmMecDRHeifR1KhRjiy05l46Of+IXAS7L5dCLGsxkKW6nE+h6v?=
 =?us-ascii?Q?mMew8ZkQdVrKfcaHhigKCrNHzhqprQxfQ26mmYX0cbI1VhOl4Kq47089JOFy?=
 =?us-ascii?Q?CPZtY3MT+sv2LF5k0BSqOLBFO7k3+4EPsmg5ygvshnj4bWrUouu3oml/P9j0?=
 =?us-ascii?Q?xn7vSK0lcBJVIVUhbiJmiwqpfJMbXi9XR2Y5q7nrjXiL0bL0+ihl/QxfXlLe?=
 =?us-ascii?Q?CyN9ujadSr3KAfGoy+fEScUw8Bdar9ShYOmlGzHOgBG+enr8ypwEB/FORnas?=
 =?us-ascii?Q?PL9cfMyDAbpiYeTU/dBvlIwP/bVB75xLKGZLie45j6MnfyID3LId0ZTkz8WS?=
 =?us-ascii?Q?Zcz/oOhFAJYWDpIApGjukMbiVXdRz4A6IlioGUqfI1P1t1dBXxi65J6kV8Hd?=
 =?us-ascii?Q?CdOvYkVsW9vc8J+s5Zau670dojUjW7xnZjmc3QQuvZSvPWsM/yRP2rTJWWh6?=
 =?us-ascii?Q?VU7LRxZ2enbawceaLfEG0h3xYckXxmCj3/9ZX9klo3qZsV+Uhh5vopwZFmtu?=
 =?us-ascii?Q?M3NR6GvvtlDM9ucvZpIWtLavNiHdIo0NXI5sLlf41/2n0ow04yNRIiEEPI2m?=
 =?us-ascii?Q?S33SEiuQqvhxQAeVzUDJeeNanNVuQXmFGcn/7svgO1KxYpEkDSkQ2+nLDGNF?=
 =?us-ascii?Q?r7JaRMyLBSjTIuJGEwnQqACiLFSCFMforjv6Lzq5nP9d3CL+temunjKRvHnH?=
 =?us-ascii?Q?TboBegeXFtJS0Llz6nLHPuate5aZnPx2luZEs+IhNZQwQ+K2+gkucu2mFh+U?=
 =?us-ascii?Q?CvHt9+j7FxxPM8gi647oyr9u4/AkHQKOLZL6s5Have49RpHUfj90l3AQJQFd?=
 =?us-ascii?Q?lMU4/TLg5w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a284b8b-1112-40ba-0f82-08de5885e185
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:41:57.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B19bnmAwF5m4/M96cHwkzS6+QAKigBy3e7UZ52cPcwcbH6YPetn9uWrM7swVsT8aBOpcG9lrgK1nvqsGAwFFNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> Preserve region information from region label during nvdimm_probe. This
> preserved region information is used for creating cxl region to achieve
> region persistency across reboot.
> This patch supports interleave way == 1, it is therefore it preserves
> only one region into LSA
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
