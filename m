Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5350340DFC3
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 00:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773881144; cv=fail; b=Gm4G8PZorSs47IrZmnyXnwBzV4+n5dGGVVRWfycRYFttdDpVu+7CTt11LOUETZ/4W7woKnsbb2W4zUeM2IRjUXgQJdSKVkINWZOtJzLnAzK0KtEMKVKxzfg2ons+jxJHFL0O/JHSkKigiNHgn7s7UG9eDCWULCcwGuCJPILfM1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773881144; c=relaxed/simple;
	bh=yJBIhsbYag0s/Zrnly1UJkdsoBaeEm0t/0/9tet3DQM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=myU5Uqihr1kIDgSVV3p8f/nXTDVsCEzCIdiz4qLj0h/nBrQwWP8IZ0mKdGJEygSQJkAM2cMrbMjEuEU+5f1R1Q3oUOvokTrCfRpXuyRWfw+fra1b4ioHSGMuNdilvAG07KrFssGahXk28QwKiSa4kXDsILSWuiqLOaZ7dMfRfHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RzuuEe62; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzuuEe62"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773881143; x=1805417143;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yJBIhsbYag0s/Zrnly1UJkdsoBaeEm0t/0/9tet3DQM=;
  b=RzuuEe62hrsRINfX3DgCBiU44vjXXjALzko9dQYniYG07ZkcCs6PReJv
   Qq+t9zVF80hMqZVS7ZAmSXzBaz/mS2O99m8H1TBUAnVJciMfbST+awAzb
   eKRgmm0F20/UPMaeXwk8b7GwIeuXH6f3hsZj58pdGnGfllGQABgVzwtfa
   /iZldP4m73W0UyMyKDEoOCidd9RvC7g3DpmONSR2708kP8xqc24uHhW9p
   lslbI0osgwf6ZItHyVWU/0s6NFrEShp6rcT+WiS6NeQ44a7o42r3LEinN
   FLMQF/4KMDUvFvCvoSc97MS8jHpJD3wt+WKJTgqYSp159AZbcTpVC10gM
   w==;
X-CSE-ConnectionGUID: 5HLFd+V1QSy2B6As0cublw==
X-CSE-MsgGUID: Zb8e/hblQDydMW4Nz1EvrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="74836659"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="74836659"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 17:45:43 -0700
X-CSE-ConnectionGUID: ysGupGhQSB6JgNUGOkSyRQ==
X-CSE-MsgGUID: 2EmlxnbGSpqcaUd9rA9b2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="221907660"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 17:45:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 17:45:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 17:45:42 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.8) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 17:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpkuyVeR+oaZcL9eHtUJr939RX0eH0YUcI8B+Ey03As5hTTdHq8rNFkNFz7cUd3mrivSAz2Iqax1sL46swOhoW3Xd0Ce9RJMk5UT1riQIGKK5iH18Zshm0MbfXDBjjmxuzPWiOsY8XZk6R6vsPBwNTOemcVYYDNQ89R2ELFdTeZyehuNNbeHt0cY6pDqzptLw4QJq0esEcQQy5KGuuEsYJBauafSyHI9XoKoU9a7keVDfiUqYjm0M4I6Gvcdb0J5WjxlSYvaJIZy0F1i+crPTDxZPUQv9uk4kJ9KkhWgn9vIwLF2kRMkzW2visPz44GRVI30fGNfehVnTSL1aP+2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JtRWjtC+QWdb+43b0VLqGcG48qSOclB1uyTaF8k43E=;
 b=YC/wFJMvDfLBh5prsv25naJyrg/Qc73LcEzj9MsERUWCfpis015V7ApNc4jjbiUGqur6m0LuZ44nUUctAj6+G45TlgjL2e97wQjwggDZUCjk/68NfO1Del4Fccy0Aw0T/R8NfqlPeCwb/Yd5/bc2w/nSefJTPPjn9PfhkP1mMviVhh/fnr7nuX41vLS9Q+6Zxvzud4KLGY1+l+mHOMnfkCIL1SvLZraV27fICFYW7ovPfG/Orm8wl/qcBrunE7Quv5Od2JrOZzokn7zforzo33Yros4c5QETBH171L3awwqr0OSUkvr5MAZq8eq1VRJc9AOvR9M3drkXKJ4dABxtLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7957.namprd11.prod.outlook.com (2603:10b6:8:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19; Thu, 19 Mar 2026 00:45:39 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::3979:c00f:fdca:b895%4]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 00:45:39 +0000
Date: Wed, 18 Mar 2026 17:45:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <cp0613@linux.alibaba.com>
CC: <ishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/2] ndctl: Fix missing key_type parameter in
 ndctl_dimm_remove_key stub
Message-ID: <abtHL3-V7pZpPvib@aschofie-mobl2.lan>
References: <20260310024102.25682-1-cp0613@linux.alibaba.com>
 <20260310024102.25682-2-cp0613@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260310024102.25682-2-cp0613@linux.alibaba.com>
X-ClientProxiedBy: SJ0PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::9) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: 842f4fa0-5a9c-421b-8f1b-08de8550d758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 3WUK7yuhtOJ/bPZHhXX69DkbSPHNfPe6J1UR+HgRJJt6Eh25g1raCWSrgxF6aCXovvX5hgGyrtT9faSM4ys2T2hKcAaY4W2p9gOKDmCdy9QGddgPHIchyF7WKirmoR/nqmH2m5+PyBf00XgkGcuh26iPkcgX7w9RDlUlrPbp+4fXn3oUARkgdwwYhmuNNChWxl8Y0BFP9nORWiDNDFn2VwDe7dXRIglzAZzNTukQdefzGY/f6WzlA03DtCpdHgaCFN2I9K14zrYo7v8Sf8kbw7tdCD1eXOtWBKATLAPDyjWgpOim7d2sZmn+R0OL2Axm9d1vvw2mjvRVNRB//ltGQs/Dgz8exVpMML0U2har9loSiXmygoQ78Z8540Yux6hLxNTMrzYco7Vz8Aobx2Drah25BGL1VadJsei1NUDGEL+gfy+aHNnfWeI8UzkmDmUpyys/8w0a3Gk9I3mdFHEcwvt5a+dt8Ra1W2z/Tqy8XSTWi3MizdzLsLfG6VkS7KOTwe6xqRmr3It/8XQPBkMK6vvfsHSPfIpwUfL5JPV8lVPm6WEgjDyEtEoZnkwKKdRtkIiPEVdbUves31hPPeABkJkbRvgM0tK9EgQHimm4QGBuosFiHhpjukquY/CL/pYJ/34AcBfoo3MHW/bC5r9urg/9Zi2LqtsxHef7y4cEfa3BGsHFMdP/Itpmfl5KI62Cb1iFUhwXJd669S44oG1M/iq1eVh0nXi9xRrbmN9AiRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFpjSXZTMTNRb0tiRXBLbnZyZE5ZSGN1TWRjYW1GYWI5SExIemJXc0ExRlQ4?=
 =?utf-8?B?eGJRcDA3WjFwVXB1SHhEUEZSZnp3NkRXamEwTFZ6aWNUZjNwRDloS3Z1RDdJ?=
 =?utf-8?B?NnNyTVVpTGwrbTlWSGpEVXRJdHRrQ08rU0dNaktBdm96WFcwTHRQSkFMazgw?=
 =?utf-8?B?YjliY0hWVktwNzZtVi85b1NrbDBhVG9NclY2L1dQRkFqcFo0WXJKbVRGYVpa?=
 =?utf-8?B?U3c4UXVacmloQ3NSYVpyeFRuSVl1ZXQ4dCswUHYzR3pGb1BIOTZEZEgzN1ow?=
 =?utf-8?B?dWFic2RobEN0VllMK0QvV2ZuRjd4Mjhvb2I2VkZnb3VCbnFXc1hWYVZkMExu?=
 =?utf-8?B?ejV4UGpXTzZuallsS05IdnJzOWFTallzWkdhalQ1R0pTRUtxY3l0TkNyUnFV?=
 =?utf-8?B?VVg4eVlPT2V6Wk5GcXVVL0xWSFVPdlk3YW1hWGhVS0ZPOEtmRXpjK25BaFNZ?=
 =?utf-8?B?ZmhXVG1idVk5dEIvbFhkUEVZU1dMd1Y2R1E3QUFJZHBvb0hmV25ZUXFNZUhO?=
 =?utf-8?B?R29uREtRcno1ZjkvMlRzZVd5TnUwNVN0NUdESndSREdmL2lMWFAxV3hHQXFH?=
 =?utf-8?B?MGJNeHkrRmw2bHhTU2xOMmU2UDd4Wmg0N0FObDRONlcvMnJVKy9ZWTNBQ2Fl?=
 =?utf-8?B?SnFnM2xFM04zekwxTVJyMnB4b0ZOKytCc0tiVjEzODFYamFPOEwrNkpiV0xC?=
 =?utf-8?B?YWVQbDJHNUo2YVdVN2xPTHAxK25PZ0l3YnJPbG1INFZvM0pDbW80WlZYLzk2?=
 =?utf-8?B?TVhoaVorZUFqOXBJcU94UWczWDlsNW9lb3R2aGUxc0ZGeTc5TGFXRGNIckVT?=
 =?utf-8?B?NUMreGNGa0U2cWZLYjArQmRHczY3cW5Sb3JWWFkvbUl2NGpldkxWVHc5bUx1?=
 =?utf-8?B?Rk9mN3dCbHlYM3g0Q1ZlbnFTMWxhU1BHWTVIVzFkc0JCT1pkcmhxVm42dTlZ?=
 =?utf-8?B?bmppK2FFNXpXbzViWFpvRFhwWFR4NWs2Ly9wSVd3WGdrV3Uvc24ydzFJdHh4?=
 =?utf-8?B?L1JFS01qUHI0NVNFOXVwaHBNajlERFcwR0JoUUZpOWoxVUM3ZHJmQk42ZnFJ?=
 =?utf-8?B?MDlBaWdDc3Z5ZDJGdEhJb1hjUzJ3bXpkTFBLWEJBUG0xZFN4YndDSmxnNVFv?=
 =?utf-8?B?OEN6aTRhTzkzM0luSExUL3d0ODVqUWNIS21QS2F2N1JKb0k0ZmxzZTdDRDQ1?=
 =?utf-8?B?VWcxR1FOeUIzMTFVZFdIZW1ZdExFL1VvakNFQTlxWHJHS2tNdWM1ZlRJNnVm?=
 =?utf-8?B?OTRzV09RS3hhbDMyNGpMcHc5bnFrZWszNnMrZ1A1L2p5Q25jREp5TkROSm5P?=
 =?utf-8?B?WnBWUEVDZWJSVlIrQjNSNEgrUEFqdGxBL0tJa1RwT0JUcWtud2g2eUFNK0lY?=
 =?utf-8?B?ZGYwdU55ejFtdU5DdmgrQlhxYnF5ekxDSkJrMXVYcHZDT1I0b3FBcGhGbUVh?=
 =?utf-8?B?aFdGMlN1SGovbnE2WHlWc0txWTlwNDQyVGNGZy9renRWK3BYQ3BadVdCelJz?=
 =?utf-8?B?YjYzalpGU1hrTXVoZmxZQlY2WDlxWjM2WHpwSXQyOU12czBxT1QxNTAxS3hL?=
 =?utf-8?B?ZFNGSHRtQ1JoVng5WHpOY1BFeklCVlNCLzNwSUFpcVlPRjRQd1hFcGV3Mmh5?=
 =?utf-8?B?TDVldFhUQ3ZNQVhvdVR4Z2xLQXVoMG1pbXRvN0N2Vis3NTJhK1M0YitTYzFo?=
 =?utf-8?B?R0FiVXhCbHlaMHZzR1NhOW9zNHVJeExuWEx2SU9zTDFYZ3VJYjkzOHdFUkp5?=
 =?utf-8?B?bkVpVHA5Q3d2MEsrZWhXSGtkQUUwT3VrNjM4Q2IzRnF4cDJGelpKc2xtWnRK?=
 =?utf-8?B?VW5CYjNTSEVtRnVMZkUxN3pxSi9SQ2RFdHZORzhUd1ZFSFVzUmhQOE1KMTRk?=
 =?utf-8?B?dWVvbWVrcDBpT1FkcW5PL2ZFdEFtZVNXM0xZZVFuaFQ0NzlmUjhlWGkzRTh4?=
 =?utf-8?B?Z2FLYnZ4bGFCYXlRUXRUbXk2ekEvZk1MK25JV3ptT1RLeDczQ3VhVUo1M002?=
 =?utf-8?B?Z3AvdmFaZFlSaU9xTzFqQ2hLYktpQjZHMU4xcURBZEpVcldITGZTaVpSekJn?=
 =?utf-8?B?c3hMZ2UwcDJ3bDgrOUFxMVBncjRTUmFVRE5zS3ZCY3JXU2p2bjUwZ0taZkwz?=
 =?utf-8?B?Mkt2Nit3RTUvY3lWdElUTStlQ3o5YjZLd3JpamNqczdybUR0NWZ1UDdsOU5E?=
 =?utf-8?B?QlEvU2IwZ0l0VXQ2V3psT2xxNEFFSGxSN0kxeTZQTFlydDFWbERSVHQ4am5W?=
 =?utf-8?B?Qzh4L0dKaitKRVM4b0pKVDZkOU5mcXhveVRtTVVuZlVucTNxcXhtYnNjbG1D?=
 =?utf-8?B?aVA1OENIQXkwNEtiMkQvUVEyK1IrOXVXd0NsU2xjQm1CVmJNelp3cmZENy9o?=
 =?utf-8?Q?tgaF+GoktJw5zBtQ=3D?=
X-Exchange-RoutingPolicyChecked: aC5QoGS6ZNg2ucU7QATibLdmlOByIHev7pWbUw9Fmsq7yipKIkjmwNAOX8xyzOD3dZ7c6U1ezjZesNXvFHsYUiaYGAsjiDhW3HSrGYboY5emelUd8ub9iSsw73GlHV4wT0PPt24GxEDPu5b9c/tsAVFslnJLpvj+5eV5vdMiB+PmhhDfFW4QWvrZlwAD8TciUQsVJMCusGUymzBOo8niaoIcGPvhbIMdAqxZfErBmTvPvk2BJ4Wpt0i0XoQqr/NMqfL/SMMPu/2dibxKEMDb77IlEL47LG03uF8A+ItVIpxqOql+OQL/8R73bPQmuTU3PWRjWd05Yrp/aTcFmalohQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 842f4fa0-5a9c-421b-8f1b-08de8550d758
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 00:45:39.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2olk3AwiBi/d2P5HtS33UQ1cE46MSmrm11uOJd4eihaXIBf8ioUInJlM1DxzL1KjLttf2GJcKCZ5F0ItpXXQHvoKf0RslwXwrgpzwTzY14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7957
X-OriginatorOrg: intel.com

On Tue, Mar 10, 2026 at 10:41:01AM +0800, cp0613@linux.alibaba.com wrote:
> From: Chen Pei <cp0613@linux.alibaba.com>
> 
> When fwctl is disabled, the following compilation error occurs:
> 

Thanks for the patch Chen Pei!

This failure does not appear to be tied to -Dfwctl=disabled.
The mismatch is gated by ENABLE_KEYUTILS in keys.h, so this
should be reproducible when keytuils support is disabled, 
not fwctl.

Please update the commit message to reflect the correct
configuration trigger.

Send a v2 of this patch alone, since I've already applied
the other patch in this series.

-- Alison


>   ../ndctl/dimm.c: In function ‘action_remove_passphrase’:
>   ../ndctl/dimm.c:1030:16: error: too many arguments to function ‘ndctl_dimm_remove_key’
>    1030 |         return ndctl_dimm_remove_key(dimm, param.master_pass ? ND_MASTER_KEY :
>         |                ^~~~~~~~~~~~~~~~~~~~~
>   In file included from ../ndctl/dimm.c:25:
>   ../ndctl/keys.h:51:19: note: declared here
>      51 | static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
>         |                   ^~~~~~~~~~~~~~~~~~~~~
> 
> This patch fixes the issue by adding the missing key_type parameter to
> the stub declaration of ndctl_dimm_remove_key in keys.h, ensuring the
> function signature matches its usage.
> 
> Fixes: a79375a9b0cd ("ndctl: Add  master-passphrase removal support")
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> ---
>  ndctl/keys.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/keys.h b/ndctl/keys.h
> index ce71ff2..b60c209 100644
> --- a/ndctl/keys.h
> +++ b/ndctl/keys.h
> @@ -48,7 +48,8 @@ static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
> +static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm,
> +		enum ndctl_key_type key_type)
>  {
>  	return -EOPNOTSUPP;
>  }
> -- 
> 2.43.0
> 
