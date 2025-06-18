Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B8521CA0D
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 21:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283668; cv=fail; b=p+Rj3tp29VI/ULMmCq5EIJtGp5frPqQLBVTb66hiJDUfSUFijW3hUhFcnw4A2KZT7ZtFD1pYNWAiYUKQoFcbYNYL3SOuHC912bFlisCCZDi/bTyOH1VxPSdcuFO5Lczo/HJT3rjJ0b2snKH+rfINyYZveEMQtFH4IYV/pWzfUe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283668; c=relaxed/simple;
	bh=H6AJSlx3bJxeCFhkcDFmu+Ym0K9JMX/hHubx8o5D2As=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KWv50QrqGaZenQw3XuJkc+5jvoeoBPEDpQFzb3AfJNXJ5uvphKOA5DNdP1aIiDS+aLFfW2qFicvHHx4O0AoFXitzPRpsmoIh7XLpatOjStDNUQRUWb1YtEcq+kb2FRZLQLl3fy8xwPQwyqGiyoJAg7eKBf/CmknavhGWM+ElWG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6Qy3ns1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6Qy3ns1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750283666; x=1781819666;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H6AJSlx3bJxeCFhkcDFmu+Ym0K9JMX/hHubx8o5D2As=;
  b=Q6Qy3ns1KABz4TIKdUBrVCPXrfb0LLJ6rYZI07RzMVQ0O3ilPPhz4CCX
   MkhLE44qIbdyhjmFgaTDCBtu4KbYL0UVMNPWAZ6Dep9IKtJbC7pRRB1oj
   DqV+I6VU/PTmggnmyjMURoEYxq5HJLNu8QaKxI7gJs/O0G6dqjXJOHqWv
   RfPhubpL9FK91ZbfDAq6YgXs96EQ1NZHv41lHx4h7rudhrP5ocXWIcW76
   /m1PI4624JiUd45Gu8Ienq1HBP2/3l1Rop3PyxWlIQkhGSMrm7JJoKUHj
   AptelRkTQA3x+3e6aZwtC6DZsocQWAEiykEuUaov1KgdWtCfSd5OpZ7LW
   g==;
X-CSE-ConnectionGUID: kRTir+2DT1iw6YrbvEGwmw==
X-CSE-MsgGUID: SuAHs3KEQNSMPN0IFeFu0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63566088"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="63566088"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 14:54:26 -0700
X-CSE-ConnectionGUID: frk663mRSZamrhTcM3elyQ==
X-CSE-MsgGUID: Z4F/+fQ9TGqvN3rXNr50KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="150335518"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 14:54:25 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 14:54:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 14:54:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.73) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 14:54:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2tel9yfycBBBiaPyg0j8snuvoJ+FiI1OncnChvpYSMuTcmm4uc16i+2qsEfI8/ji1Is2KKOqwLGQI3HFSDFcWZRVeuL56paoROECNbkQaL0+Y7/cquynCwVDISpc7qkJ38cvw+21sO62cKAlgHgTaMYPcviYuZ5xq73Y7KAzlaek+1pW/6RRHzIWgWZn/f2ZYzrHnOjNsYREtb3ulAeD0/BfmpfS5LtXF5CYtS0cd6nPYUAJNK6EXNLaF9BP3Z2oHDdhLyIvwWpK5exmlYqFM/IWlukbSfWpPhubQdxWh6g7gl20Ma0cuBJsJNvZ9zY5XbkOES7nFQ3jR6SSINgPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1KqXxgt2dflxr5/Y0rT0R6urjVwUlEbriXMakUdQ4U=;
 b=WYs/VAV5zTUhjB3Jpm6mNZ4SCredrYb507vGlJCWcu3KqYmB386+TxGhMqECy38fFTIEfx2HDaAR/pBL4s77JuUeyFh10SNPaCSPPOF52+mjqhP0A9mX1VW1f0QXcazXzVOa7dwM0RrW9jFOHLSzKadioNZdeNMKgmZvBpD0TcjHa8gHS2FPid1lyXywZz27xrV1I2Hfzob7gmTD9Q6TmRkiUy/T8+/JLPIbh7Fqpb6r97rpexjMJOcWNNqi0EFlaetwvOkggCntFDVAyKMwYQ/uIkfaKcf706EzZqKAo8ToAJhiZft6h25p3+/FQJNFzACnRtl2cyUoCCzNhvXSXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by DS7PR11MB6200.namprd11.prod.outlook.com (2603:10b6:8:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 21:54:21 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 21:54:20 +0000
Date: Wed, 18 Jun 2025 14:54:17 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl: Add helper function to verify port is in
 memdev hierarchy
Message-ID: <aFM1iWWREEU_dlyF@aschofie-mobl2.lan>
References: <20250618204117.4039030-1-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250618204117.4039030-1-dave.jiang@intel.com>
X-ClientProxiedBy: SJ0PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::22) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|DS7PR11MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 849cbb32-68d5-41df-2894-08ddaeb2ae2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Bb7kDmn4CeriXNGlOhXOLHQ8lIZdfIHXltm8HQesbS2oiL03iGwy2QPuM8aL?=
 =?us-ascii?Q?yuL4hACZX/ZlHCxF8+No2g2tkkcap0SFL9QdbO+ySWKsMlU76gp/AqG1xuOZ?=
 =?us-ascii?Q?NK4T6V2rVA5v19PLllivyEuWVG7TYrq+8F6Mry18kma655TUpt3UIzBq94x0?=
 =?us-ascii?Q?/1J8PNauIJ3WjKWgNYgtUrMxzcJQ0rlRF9/M6n7i7uwQ3ADXbPH2qKpa81An?=
 =?us-ascii?Q?rI/LyF8cam7i2K5dTFUKFz1J0LDK57fI2nVlkONqHmKqjcCphngrednmaT6O?=
 =?us-ascii?Q?186xDEo4j1Iu3V75LOR140h+giZK928/EjxWK4WN52g+9BI1VpyAVY0d5isz?=
 =?us-ascii?Q?cmuvlEfQyjwq/88mRTZ0g1EAy3vOKwULj50SxDFMgbBJ/rvckBWJHqYCHisq?=
 =?us-ascii?Q?et0eRZ3JG+JdKvKW+axguA4JZRPBfs8ZlI0nvo7mpQrwFb1i+uVCAW3ce6pU?=
 =?us-ascii?Q?8J4nUvfjNe+pjm0RSckLQYTvSOTPxP/327oKd1yXb98UF3iOHB8j6WWxxI2N?=
 =?us-ascii?Q?e8dzFQU8g4jRAh94pzBwoxnCNHgmeAhdo+/Ca3lVL0NAiFqUqpX13wLYzGVx?=
 =?us-ascii?Q?0YQgsujAC1A+O4EoJ2Re3eNZxuYoVjIzH07FPGxTNgldsMCATWwSm45MM9rx?=
 =?us-ascii?Q?sbuqeazwIWPI2iJWzMGbBWmLsFrr9nH0cRD0KbFK6M5MckCbCARo0aCGsnSV?=
 =?us-ascii?Q?J34NTX77Hxw6Agxpg9gKpygmU3xCa83Rfn89h6d1Vk0g//fgEob4DXDkAJuC?=
 =?us-ascii?Q?vnaehE2QFYWiltPj1SS4g4gnP1g1mE+bZ7xyyhymG4Ifh2Cofj2gJ9rlyP1r?=
 =?us-ascii?Q?+69OQIUO8OyDABGozMLxOal1dboNpI7TOZRCXVh3bpEEZBYzAK7hh00A1Fef?=
 =?us-ascii?Q?YfG55cjjdfAGH9QPpOoR1uMZrqODah7VLoIqSvmIobSaSdLixJz687TCRIpK?=
 =?us-ascii?Q?6zxrDyxERHGxPJBV6VSohDc7LcXZtdRHG3WkPr6FU3a+kWGY7nKqq0zGX+3h?=
 =?us-ascii?Q?T0/w3fbbudAp4Fe8psTf327/zYeUE2qCoB0Skc0Nw3Zc+Dy6D2zI1Vk8U2bB?=
 =?us-ascii?Q?E9U9aiUm90v27hQ9lgwsBABntIlg21ESvUF6hZaZBq/jw3dxMHcB7o/0fVI1?=
 =?us-ascii?Q?h3MalsDQVNzQfmSM2cd8Oqw0POsXIcNWsCUG6Kztws+sv9hMq4V4bfxdeSTV?=
 =?us-ascii?Q?O/MWz1SDBHE7LYjNYxg+WRIW/5AO65lqWspAgu2wtwdwQtnluBIKK34DbZAe?=
 =?us-ascii?Q?NvTe1avx7J0pIpktDS9ai42ct/gK1f5r7M3zUeMHiPaUk2qJOux/vCrWtUuW?=
 =?us-ascii?Q?GIsDxTwnwdvDCIVyVqitDa4ZQ9zbCx2EewKojLdtwtDGBDWlsUyWJDo0fSXS?=
 =?us-ascii?Q?OJT7iAVOW6vZBsObX7s9g+ZRGemkA5CmvYYj73lw6UWc7WmiCQW7GO72VeVY?=
 =?us-ascii?Q?xZj7kRI+6FM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8QM4xiZLo0ujWd97I1A2pn4aSjMxZ3Sqxah4YMc0mBksHhQAFKxv5qyrKqvh?=
 =?us-ascii?Q?ZFhvWK0+47cxuC4JxT8d4totSfTsXwPgqxmX7GRaRQM1hXsBrX2H66DV+s9m?=
 =?us-ascii?Q?WZ5AW2ub1wZl8j9vUej17O/oV/yX8bZBBcUG+n5z4SIKCwfDX/CzL4xcFXsY?=
 =?us-ascii?Q?fYCSzS0aQSDSB3r5ueAxhokMNt68kuZx9jTfkXo/ObSc6unEnGsLHyxzP1+J?=
 =?us-ascii?Q?tGg0K7BazhXPupQhsp7rBOVfPyIoMPiVCFBhw6MUKfw14qXQoo9DIU94HP0V?=
 =?us-ascii?Q?+1oNTMysoe77iNnfwbtesWT2KkBF6cXI6dpsERxZenO7btHQVBoEv8Imydhs?=
 =?us-ascii?Q?DXc9Ht8Pe3AJsRGabgFrznnP3UnC9SyBWJK4bxYkkF1Kwl9p7w6cQj3Qslio?=
 =?us-ascii?Q?qGwKq5AvRPmiO9oGfgDQE9rcamaAsVYrxxdOrzkaRz++Uo3vRFOCYFZYjET/?=
 =?us-ascii?Q?ZoA6+xAmnmbKSZIvdKUlTzCluymAssXrsYoyTiBrn4bRsYbi/kvmPLJGAnz0?=
 =?us-ascii?Q?iY2UNucxvsDM18uTYa7W1iSmi/AB7sUznChQCD8wGX4vRKuhHR3Emso+85Ea?=
 =?us-ascii?Q?BPOH6M5hTrdWwno1E2x/f1ljOGOIrxgXC2Fa6prGEVSzKBLSDWsy9oQZAAcz?=
 =?us-ascii?Q?UQes9y7k9Azeuv0dlGmgIb0nV+tRYr3ZMr+8y2w5wfTqsZ2P59H74EgMiiPc?=
 =?us-ascii?Q?i1biRshGuRXDq0HFYKDmbpmdwZu0qwwmrmNqvWE6SObvIpzUPQW7Xda+23I1?=
 =?us-ascii?Q?CuVnqnRLfWBnkHvwPpOqzeYINjSU1vk4kk69iW26CIx1rwlYvg+lmKS2a8NR?=
 =?us-ascii?Q?P0tdge4mNuA65yjg4cUNMMkp5thqy67kfel82v68bsuUwiwbjxfMhG2JFEdi?=
 =?us-ascii?Q?wT8WBNjA/jh6VCqAdv7IhmOmrlS8RO39QGOmZWzcamUCjxsCPhgILhp4+iZL?=
 =?us-ascii?Q?QZf8DDQ4m+2xkVAZQUnRh9ClRIjqAMtECHsveKJsrTcF5l93pKQKbLnyZgRL?=
 =?us-ascii?Q?FTsckFaj71FbiNyM12k/K+FB77VWlOwolrin76zCx477cHlos3cGrwAa4wTp?=
 =?us-ascii?Q?sRh/1uOtfvSwjL21EBgfP95N5K1r1i4M2FE24sHQSFYQsSP7fxgXwRCy6t7b?=
 =?us-ascii?Q?uynStmWJArl8LOWXufZFdm95Gv6ufowYJJ6EW/rBu2XmABrpwg5gJvBCmSHl?=
 =?us-ascii?Q?kJHpSrZgAYxvMk2IdjwO6zKoForOGPzk/ZAYORW45cL607Xq3tWBvS4+pjQ4?=
 =?us-ascii?Q?A1PjraUy2mkwkYmqGou87kWOIzk1hhB8nwOvB0uE2aAR5TVU0Uz2AiRDBH72?=
 =?us-ascii?Q?iEoTw1QVQ3K4XGKBa58A3Kjx/ge9kSdugaljwpyFy3ArcC8NiIsFdvsyGXuI?=
 =?us-ascii?Q?D4qxtH8dPw3ZBRmQXOIfqV0mC/0okQ1/KsWyHyFHkkPhUhIX6UTX+b5jS6ei?=
 =?us-ascii?Q?mnnNEcH9Te+A4ytr2kUHCAech4LZTW8/IKj8X3kTukdDydMpPA/3+7uMV7fF?=
 =?us-ascii?Q?oTDndmDcymELPpwr7weQLEmpqovgNLKObixisl/bDfbqlyfe4Ivu483eS6YX?=
 =?us-ascii?Q?PqX0NrHswEQimvnpIqPJkrEjuI4+bWqnRQXEq92tU5KZBIogOSzp/S2nSoEJ?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 849cbb32-68d5-41df-2894-08ddaeb2ae2e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 21:54:20.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tXGSjq8l+KGuDTi5NpLt+nLqwaRmKzIIWRcGWm/KysAr3AK0mTsSPBRCbQRfX1Hb3cth1NaDrtTWsgCHzR0BhIOeIksP9JLnlv5xfkUL1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6200
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 01:41:17PM -0700, Dave Jiang wrote:
> 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
> memdevs that are associated with a port in order to enable those
> associated memdevs. When the kernel switch to delayed dport
> initialization by enumerating the dports during memdev probe, the
> dports are no longer valid until the memdev is probed. This means
> that cxl_port_get_dport_by_memdev() will not find any memdevs under
> the port.
> 
> Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
> port is in the memdev hierarchy via the memdev->host_path where the sysfs
> path contains all the devices in the hierarchy. This call is also backward
> compatible with the old behavior.

I get how this new function works w the delayed dport init that is
coming soon to the CXL driver. I'm not so clear on why we leave the
existing function in place when we know it will fail in some use
cases. (It is a libcxl fcn afterall)

Why not change the behavior of the existing function?
How come this usage of cxl_port_get_dport_by_memdev() needs to change
to the new helper and not the other usage in action_disable()?

If the 'sometimes fails to find' function stays, how about libcxl
docs explaining the limitations.

Just stirring the pot to better understand ;)

--Alison


> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/lib/libcxl.c   | 31 +++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  5 +++++
>  cxl/libcxl.h       |  3 +++
>  cxl/port.c         |  2 +-
>  4 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 5d97023377ec..cafde1cee4e8 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -2024,6 +2024,37 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
>  	return is_enabled(path);
>  }
>  
> +CXL_EXPORT bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
> +					    struct cxl_port *port)
> +{
> +	const char *uport = cxl_port_get_host(port);
> +	const char *start = "devices";
> +	const char *pstr = "platform";
> +	char *host, *pos;
> +
> +	host = strdup(memdev->host_path);
> +	if (!host)
> +		return false;
> +
> +	pos = strstr(host, start);
> +	pos += strlen(start) + 1;
> +	if (strncmp(pos, pstr, strlen(pstr)) == 0)
> +		pos += strlen(pstr) + 1;
> +	pos = strtok(pos, "/");
> +
> +	while (pos) {
> +		if (strcmp(pos, uport) == 0) {
> +			free(host);
> +			return true;
> +		}
> +		pos = strtok(NULL, "/");
> +	}
> +
> +	free(host);
> +
> +	return false;
> +}
> +
>  static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
>  			 enum cxl_port_type type, struct cxl_ctx *ctx, int id,
>  			 const char *cxlport_base)
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 3ad0cd06e25a..e01a676cdeb9 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -295,3 +295,8 @@ global:
>  	cxl_fwctl_get_major;
>  	cxl_fwctl_get_minor;
>  } LIBECXL_8;
> +
> +LIBCXL_10 {
> +global:
> +	cxl_memdev_is_port_ancestor;
> +} LIBCXL_9;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 54d97d7bb501..54bc025b121d 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -179,6 +179,9 @@ bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
>  struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
>  					       struct cxl_memdev *memdev);
>  
> +bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
> +				 struct cxl_port *port);
> +
>  #define cxl_dport_foreach(port, dport)                                         \
>  	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
>  	     dport = cxl_dport_get_next(dport))
> diff --git a/cxl/port.c b/cxl/port.c
> index 89f3916d85aa..c951c0c771e8 100644
> --- a/cxl/port.c
> +++ b/cxl/port.c
> @@ -102,7 +102,7 @@ static int action_enable(struct cxl_port *port)
>  		return rc;
>  
>  	cxl_memdev_foreach(ctx, memdev)
> -		if (cxl_port_get_dport_by_memdev(port, memdev))
> +		if (cxl_memdev_is_port_ancestor(memdev, port))
>  			cxl_memdev_enable(memdev);
>  	return 0;
>  }
> 
> base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
> -- 
> 2.49.0
> 
> 
