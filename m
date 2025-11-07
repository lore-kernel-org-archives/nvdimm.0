Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE45285CBA
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 00:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476268; cv=fail; b=jXKiLqcf1VL2qcl2yj9peCuy5sx6XEEFkvJxvdsTnpbkdCHePs81kIooCfkaxQeukAqOgyovakTIlsTEZ1/7ySmY/rrfCBYuA0vWOU0vMMZ/P0xP4x1lDn2yyUPJyLQZMNpN0ZrCIfheRLOpKp/agjxXZdp2QBWuwbWLVkEHJRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476268; c=relaxed/simple;
	bh=lnG64eUBdCZSbsaXCPPI1DgQN+kfNE3Bq3PIITHjYM4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d2iWPlVj4U3cySSg2ytNtXqn14t2Jyv0Os20UogEG5Lc/0CdQTc7/pD290ObTVVHlFY4/njkrV1X+NBBys8O+aRkPkonQgn3QPT+y8C7vIUIEqKt7rTizR/M5gKFl8cJTbJfn6fBSSuZWH4kjTViJgka8ipkPz/6Ie8blS6B3eM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bT8pgge6; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bT8pgge6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762476267; x=1794012267;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lnG64eUBdCZSbsaXCPPI1DgQN+kfNE3Bq3PIITHjYM4=;
  b=bT8pgge6ZTKwazDu7gJ0/jY+po7lsSAVspuWp13DObE/QL12Ol+3ahoX
   ZgshNYEn/PMammMWhZChUG5ZpHoST6a5N1ElbhZpemfAHOqU6vYyqqoY8
   ZeCzFZlHrmvd12f2RlCHwWrOPJ7kPHUrLJMvqSD4VtY0cZFSWQbUznGgF
   T75V3QuZubEMwTsE4adR3Q8kC2JRiGrzNCqZstxJx1So+UaCCAXNGZmyY
   Vp1W+MP/wHN3nGNEbn/qKRtpBtEJ4dTIUujOC200jGL7eGsp7/txcEqFG
   ZqbzFnZ+iCCTZZxflGBUIgV/jpQcUn7m7gamjW1JFLY8OabyhS6iZ25zw
   g==;
X-CSE-ConnectionGUID: ++tkrFVTT7qdpIU/bjgu7A==
X-CSE-MsgGUID: MXSttP0OTmCIZKOeoM0xCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="68275402"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="68275402"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 16:44:26 -0800
X-CSE-ConnectionGUID: 3yDosQ3ZTJqbD/pDrjikEA==
X-CSE-MsgGUID: a1NZ0vnLT4iViM9/f6pdfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="188178049"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 16:44:25 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 16:44:25 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 16:44:25 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.4) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 16:44:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4ZXQJD3rE6+/6dS/3QOPUNouMlH3IxZOJXH4GeqP06RJoSFMQW+zWMj8smsVqeyEOKWfU2Fa4VkxfJd7BTiVOOVBRnhbEpTNsDUnRSTK7P2ajqo2AvKSJEQe2FW/1Rgduxue2UQm5UE6BE6vHH6lnsYgIH4qmziPgv5DhQHSfeVz1d8afax2ihvK78JW+L2n/TnfC1dHwpQQGlexsusc9MkIv9VgnwkU5+GmBhhv/LyC1hOWkxAySlhoofC16408g+6fhIbNcFxde9FiX2mcaao9k9moOoLFZ91fto5uX0peLV6ZjnugohQY0MDHEmCvGpJS49cgX2mCXxo4FeIEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeB9krLJZaBwDkPxD6hpG9yRMWMSk5l4AKHXM6siqEI=;
 b=WVK5oCRXi4QXrTT2SJ5XHeHRT7gr0NuVJELUoA5GenZ5tNBrZrK7tbgoJrfTbH1nEv1gBI26TTFvsGX8fnE4JRiHCOd8KgRawUNggDU7eYvj2xr7GTDdm0ZjkkrCpfFEhdPSd3KVZiGb7lqsHFYI/TTEakT3o2kk7xoR+u4QWszRG9pwKxLW3XRHERZ4cBAIWdyq7vLGZ+Qta0vj3RT+yoquXRGEzachKDUqy9DvvMtcwjGwzcjcHK6eYEJNf7mF+cf/s0c/2axbXoQMUE4eWXlry/Z5DIY6ZZwW5yi34U0qtcQiB0kMg/jD1APslPYY5qniZzIdVbVTlHC6N5BDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SN7PR11MB6603.namprd11.prod.outlook.com
 (2603:10b6:806:271::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 00:44:22 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 00:44:21 +0000
Date: Thu, 6 Nov 2025 18:46:48 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <690d4178c4d4_29fa161007f@iweiny-mobl.notmuch>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: BYAPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:a03:80::22) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SN7PR11MB6603:EE_
X-MS-Office365-Filtering-Correlation-Id: 68cfa121-3830-4309-9bf5-08de1d96ca9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JdQKzPYqbkvkNNG5BzcXkF/Bs8fu+ccH3QBe6bY5U2SFNPhZ0noz00FxeNTK?=
 =?us-ascii?Q?oINDwOAzy+Gm9rfTuk7NXQhWWPBlmIeUwGo44Tb+1aN1sWtkGy+8xxY4LmKT?=
 =?us-ascii?Q?vtAbiFq39tiBs0apWQflaJsD03JVIL//wg2vwj0Fol2Vhu7hJ16Ur+a7/MOd?=
 =?us-ascii?Q?VaSS2TUUXnY1J9p7CtuExhFdLKD2gsBUla+USIjtM5FzdIv8LkbFr4S2Szl4?=
 =?us-ascii?Q?PuaO9ndEANTIXMB3gzt0KKk/yO9zWehxz78z3Cr1DG8VgmJUnY4NqSr2mEHg?=
 =?us-ascii?Q?lC4n9hk/JWT/wlLU2OXwiOamwx/2w8cbxNNKRAQf+at1F8zERaslH/VZAlDL?=
 =?us-ascii?Q?p4JTrxlQUEiMbZs5jFVC1vtwqTlp74VdgZ+uB34WaZi87XsU95XQQHk3dXnl?=
 =?us-ascii?Q?ai6DQ1jWCrhCnRieu43uQO6FvHVTPbVLHwvMdle5XmwHlOztT1kQXHG5joT1?=
 =?us-ascii?Q?X/qPsPUFVBc9FkKpKvLRiuEs1ZuBtxG/bHv+oC/mim/39FSmWdoRBssk6GqM?=
 =?us-ascii?Q?1p1YAO18cyQVJb9K+PQlEhnBwiXLZLIG+qD7MaR9PyzRS3ITPkYbefFB+siO?=
 =?us-ascii?Q?Sxgi1rwTkQEzvzb+mjeBOgMwmSV514Z+YzdU9pMNOzFCla4HVwKma4cEZ4eH?=
 =?us-ascii?Q?dUhREkFubvgBypu6AgcaiX4bGSRHrHbR5UCK+eedP0aerDU5C8NWxvPUkkyE?=
 =?us-ascii?Q?9DyFk+BzMgmXNOFETKcZM8LgQSPVZ0+EhVXMWB092Oek9x+0gB2ClN4QLmP9?=
 =?us-ascii?Q?ueE2u2SpTuMpJ901kGaGgngrN3b/DD79sMzFHjnQEeY36qzhyruAUa1TJ5Yp?=
 =?us-ascii?Q?daFln+TZ+Rq/96hIS1OZpoy55nXtMEW/Wx+R7jUFl/cQKtDUSVQ5bvce7TMJ?=
 =?us-ascii?Q?2xD0ofgds5XbYThn+WKt5pjRPkcVn6xKGp2aLoYDMu7JszfWP8X8J/tip0ag?=
 =?us-ascii?Q?D+9QegyXQSfutQkLFel1J6H/Kd6ZbO2VGoHbBQ3Co94mh4nay5eyvsTeaTSC?=
 =?us-ascii?Q?L1BjIZTkHusdWGuFvIkoRRs1XQ0fl0DYSXSwMKPJbYRP1LQ1Ki58tI/+JGyl?=
 =?us-ascii?Q?rRfe1bweVl1uG1F7wKCsDiENF7bnB+b4UxN229D59w7+wxQRWR8iLv0qZfkE?=
 =?us-ascii?Q?NGA+mp0CWIm0s4OVsAM+RHIVEkN226Xs753dYGgdoR/sh7yx/4vXbt+UCWhD?=
 =?us-ascii?Q?0kZ2BiUuKLU1Vy3yGGCwy85hGK0qbnbxqjgbU17+u5LWXp5tGbkHXPKnqf+9?=
 =?us-ascii?Q?3zVKdh1z1GGHInD3Tpf9TKkeI556vXJvwh/Enq3HvmF1yvjYNSFzuxlVFE/Y?=
 =?us-ascii?Q?xmzumknk75PLmEucsoLkWQhKQZQbsEDG2KG6lVcaNOqZFfhNroS4ftDScG98?=
 =?us-ascii?Q?N111Ot1mpC/PGyidp0htj96ZnPAymwd1z1af3N2ORHsiV7lmBSlNvbuososp?=
 =?us-ascii?Q?CifzJ954XUeYnpFLRmVuNXWrqL7HP6RM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5hVQVOj7A0rXtI+8rM1n9r4rWxxqYim942dirycStuSWdZ8sQuA7vGqOpCSf?=
 =?us-ascii?Q?ol0s0tBq4kORlmcPzoZO0ZfcoLIFGzVWBa4VudXkWcGrrTldsJFGpcIT8sqi?=
 =?us-ascii?Q?jE6synMP9Yystj+6DrkUIZpzbHXcMz5bFC828eJTD5u+znyOmTzOnIz4VIyq?=
 =?us-ascii?Q?JHG9j2eCg/D+KlSzY/4pOIoNLi4u+zr7rKAHqGEfvv8jje3b+AYvqwS+fXKg?=
 =?us-ascii?Q?CL3srSdqTxZ0rhlAQhhD/oP7AKGvXgYfChYjDoSXCH36xYXzXEdn986uJroH?=
 =?us-ascii?Q?8NerZUJ6nxWC86rnRqqfLoXeP0CAzwuy9TE2FmX6R8h+XRfphAQZHXE/VbuV?=
 =?us-ascii?Q?AZaK7lmLnWOgE7k41QcFd01xwF/Tw8ZtgkjtmtBPnLI8VRGpGRI6LQl/m30V?=
 =?us-ascii?Q?m9Lk/sT9D8XanZp1yQWNZexL18SzfrblnguyWVisNi3JKQOqQsmcYKWvhvZt?=
 =?us-ascii?Q?6XvRVqyYlUAfwpl+OltcD6DdYtvep+ZCt2I9Ho7nnfLOZSOInzoH1La4YJE+?=
 =?us-ascii?Q?wxKOxVpk+cku/ra2FPiJ2oBmAE0ilICnaPtXa3KwKR9Jd5MahM+zNf4e0k19?=
 =?us-ascii?Q?KIO48APLcTbMg1qd84UfyZWPtcNyjARLbOA5rhDbKaof2kS9nLJmaukzSXBA?=
 =?us-ascii?Q?BA4xGH/VOFHVY1uAbousmqXMBz0QeDWcdX11O82jfPXvAx/4Z9g7860pXLHt?=
 =?us-ascii?Q?+UCmuQi28hxSmMxBHEP0LkfLKKnimCNHx0ad1OpgJgRlMCq1sIugSIrYktAz?=
 =?us-ascii?Q?28BuZgLbriPtjJ3a9ibs87GtqUZ2IA7DbT5WebnDFhPlxr326n6ef6qVqbs3?=
 =?us-ascii?Q?WB+tHrgcOaDORhyea7AelOH0n/jUbWCzlV1LfKKu3WJpMUK1PXsUAg5YUjQY?=
 =?us-ascii?Q?5ZuubZrVgdFPvS0Lm4zMqPaV1i1CHlOq6rS5Y/mdt/2HwooXQKTWnrTdtVbl?=
 =?us-ascii?Q?bu+rkZ0I/j//WAWl4LYOruaKET79mPoY47bt8bzD/9LpVXn5l5ZYAZEfHnnr?=
 =?us-ascii?Q?E9f2EN2D0vYtG2XdtdrGZE8GihBh0pSB2SZRO5TPxM0O5rrsYdgWULKZUK8H?=
 =?us-ascii?Q?MxAsveXB0aiX1oarY2SwG3O2Nd0XRJQ7LsDpeUO0e5GLri189viot6OJzRZ/?=
 =?us-ascii?Q?qSTqZ6vkwcEWKgwQDnggTTz7NxPpxAH9xj4q4e2/89UkNnf1LV/1c6utoFB4?=
 =?us-ascii?Q?ysRnUogv9L04/Vnnn5ShkFNg3Gs6Nm8xQ8TUBf9B+YzJ6IhRTHoFgDzaJmNl?=
 =?us-ascii?Q?KOHryY9hr8MN2CzMm+BYUluRc6ffS9fBLPUyy/CqBdbFUVyucdYpR6KJ0MzC?=
 =?us-ascii?Q?Zk7Cyetymg4X9xYEPedYgBz8MYPYQ9wB9MO85d7uzDRj0jsq4ub9yxBPH5pI?=
 =?us-ascii?Q?PFaF61ntFoglUsoAUadcYLz0k6CN+Tt2yw9eGVthhmBGGnEICHKAua/gGcoX?=
 =?us-ascii?Q?pCsCpom7RAR883iWnjG5w+PwLFJ/Sc8wU1klYyDs1bIf2qvnglwOMWLIO+Wr?=
 =?us-ascii?Q?L8+gxuDQUkKihCDvj1WlSq0IQVnA4/NzcmCSBS0kAorYmOMmM7Wq8QSw1I9m?=
 =?us-ascii?Q?1LYZjIdOReBhUTBT0TUiL2cpIz2nh2zXHtOWTBD6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cfa121-3830-4309-9bf5-08de1d96ca9f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 00:44:21.7523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCmSBz387i64es2kcHxrZBRlB2xZMIoqoxnnOEut5QSZijYwcVghaJwgWsEwI74zOqwzHiM+XOmImKjYfyOoLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6603
X-OriginatorOrg: intel.com

Andy Shevchenko wrote:
> In the snippets like the following
> 
> 	if (...)
> 		return / goto / break / continue ...;
> 	else
> 		...
> 
> the 'else' is redundant. Get rid of it.
> 

I still need a why to in this commit message.

[snip]

> @@ -768,20 +768,20 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
>  {
>  	if (claim_class == NVDIMM_CCLASS_BTT)
>  		return &nvdimm_btt_guid;
> -	else if (claim_class == NVDIMM_CCLASS_BTT2)
> +	if (claim_class == NVDIMM_CCLASS_BTT2)
>  		return &nvdimm_btt2_guid;
> -	else if (claim_class == NVDIMM_CCLASS_PFN)
> +	if (claim_class == NVDIMM_CCLASS_PFN)
>  		return &nvdimm_pfn_guid;
> -	else if (claim_class == NVDIMM_CCLASS_DAX)
> +	if (claim_class == NVDIMM_CCLASS_DAX)
>  		return &nvdimm_dax_guid;
> -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> -		/*
> -		 * If we're modifying a namespace for which we don't
> -		 * know the claim_class, don't touch the existing guid.
> -		 */
> -		return target;
> -	} else
> +	if (claim_class == NVDIMM_CCLASS_NONE)
>  		return &guid_null;
> +
> +	/*
> +	 * If we're modifying a namespace for which we don't
> +	 * know the claim_class, don't touch the existing guid.
> +	 */
> +	return target;

This is not an equivalent change.

>  }
>  
>  /* CXL labels store UUIDs instead of GUIDs for the same data */
> @@ -790,20 +790,20 @@ static const uuid_t *to_abstraction_uuid(enum nvdimm_claim_class claim_class,
>  {
>  	if (claim_class == NVDIMM_CCLASS_BTT)
>  		return &nvdimm_btt_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_BTT2)
> +	if (claim_class == NVDIMM_CCLASS_BTT2)
>  		return &nvdimm_btt2_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_PFN)
> +	if (claim_class == NVDIMM_CCLASS_PFN)
>  		return &nvdimm_pfn_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_DAX)
> +	if (claim_class == NVDIMM_CCLASS_DAX)
>  		return &nvdimm_dax_uuid;
> -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> -		/*
> -		 * If we're modifying a namespace for which we don't
> -		 * know the claim_class, don't touch the existing uuid.
> -		 */
> -		return target;
> -	} else
> +	if (claim_class == NVDIMM_CCLASS_NONE)
>  		return &uuid_null;
> +
> +	/*
> +	 * If we're modifying a namespace for which we don't
> +	 * know the claim_class, don't touch the existing uuid.
> +	 */
> +	return target;

This is not an equivalent change.

Ira

[snip]
