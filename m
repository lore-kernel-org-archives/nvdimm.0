Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375879CF
	for <nvdimm@lists.linux.dev>; Sat, 19 Oct 2024 00:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729297078; cv=fail; b=EDp3E2brouCas+2gfoIYk79tsDyXnPrHELitGUEykokO5Hw4X12u/cvyKbV9YeC0EhttMx3CJ2G7nQGXWs2Mw5NSpSCPHsuFdAbwQzYDeR3lDUY3Rk6eaAdoSaRM/vxI617vaBoMkH5dnCkTElAIWnN5EIvfiiXHFdi55Hl2LS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729297078; c=relaxed/simple;
	bh=DhAwtJvPskVM57SIzokMmvdgphOTyRuWFa1pnDpxKqw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OHS355DAkExVYghhUdNzh/6bqs5xVkbm34r0foK2PNHqLrp4fI7tVS37vWiEQaxsVzLhW/0Q1chVWr229dJIgp6MmcHKzXZNmPYhHy2tbUYycer//VJrdvtOc7vwAdoULGRHmySvLNqY9eInFbzFubRdrg5emkZ5Cvf+G3pQCjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hrd+QU4H; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hrd+QU4H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729297077; x=1760833077;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DhAwtJvPskVM57SIzokMmvdgphOTyRuWFa1pnDpxKqw=;
  b=hrd+QU4H8m5y2P65L3Bdn7bJSi8b3OolvVRUYI5g5TJGGaxOu2/dFCP3
   rJo/ByONLcs7DsBiKgJOCI9CUyydi/whOT/a0L8ceK+0vfARTfP2SRFgi
   6MWCFdfDt1DPfx9tTmI7FRkCnM67ni6RBRY/zez9BVScNEqRU77ThbkWK
   fRwh5dlAkejUDmJU7vfBdjIEZSbNRoVZAk7r3w9RlD50MTSkbDdeCF2sm
   UTYVWpSw2ZQozLfeiFx8u/Eo6FiLRRvf3/2Mrkb+ujAQ0moD9cXEyP781
   NyZRoqlJdgoULlteILsYMp469Kza5fBjDOOtB81YZCeUgRqD3mTlQV0Eo
   w==;
X-CSE-ConnectionGUID: /WJB4yPhT0+2PuNPv9H/5w==
X-CSE-MsgGUID: XeZ7dxgwQfiTQNeSZBoDBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11229"; a="28274508"
X-IronPort-AV: E=Sophos;i="6.11,214,1725346800"; 
   d="scan'208";a="28274508"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 17:17:56 -0700
X-CSE-ConnectionGUID: wIw007NcTy6MvjfxAjltFg==
X-CSE-MsgGUID: hPce8Jh5TG6pMOk2+eo0hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,214,1725346800"; 
   d="scan'208";a="83584483"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2024 17:17:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 18 Oct 2024 17:17:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 18 Oct 2024 17:17:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 18 Oct 2024 17:17:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qlROaA2Il6xh/P6qLaFmqXsOwRQiKCM5Wr0a86bi8PWPz96712nL2gl4PWe1/a4QAQJDAHhnP3g49STMe8HTZuftI7pdiLzzKcUkFSBjWiTA0S8QTU1mXpytDArdPSqXGKOUoIX3ZaKQ2nHCwU23PqxiTvz9qbBa+DAnwDPdXD9qEMGn5OGEObgItOXB/DSeUNYaJbgj8RvtWYStvETp2/MqA2JA44d28r0Z8bWhHexZ9FABt3cmIaqBIyNgoLfwdW4XcmIR5C0kXjCVJY1lz9CCdvxGqYM1/CgeWyenXgDl5RBeqj6Wm72zsgIH9qYKEWfA/bDFmPNqKW8KGsefaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9x3ib0cii5js/6MCdXprGIoakiQpCsiEHI4c4c31Pw=;
 b=yMHaFyQXUhyu3V4UZ8PkChSMjs7n8twkFXDe4lk1iO47gWRhVFlFlIpAx4VNdm6t0rdcDRVYHwrn0sedkM1D6XjpskATI9GJZ20RF88aB6XTj9kWsGYBjwEuvI6cI15ybSqHlHgQN4lDZ0pNscelwx7TDbb5sHISoMYn3K/PPNG1gE8jJ9OPIxo2m/9QTYjjjendb+73df6g1urV1vK2vaN/ElzvPWwpiSe/5fwn33ThcUb4HWdKnF1/UDsOgZO9sPwCvJa64teh32VX2hGdVO1tBBDxkf8MFmz8FvtpunQ0xX2HqjjCyS1kiOthCnPzkLF+kCghqgznGy/PoYqd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW5PR11MB5884.namprd11.prod.outlook.com (2603:10b6:303:1a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.20; Sat, 19 Oct
 2024 00:17:52 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8048.020; Sat, 19 Oct 2024
 00:17:52 +0000
Date: Fri, 18 Oct 2024 19:17:47 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Li Zetao <lizetao1@huawei.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <lizetao1@huawei.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH -next] nvdimm: Remove redundant null pointer checks
Message-ID: <6712faab270eb_44de6294ad@iweiny-mobl.notmuch>
References: <20240903143911.2005193-1-lizetao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240903143911.2005193-1-lizetao1@huawei.com>
X-ClientProxiedBy: MW4PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:303:b5::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW5PR11MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: e159cbc8-b818-442d-9c6e-08dcefd378d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DSyFyhgKfgDJQMS/XTr1masc5r16Y/tNo31T5wA22qjoUG96yKq/hlzdgXKo?=
 =?us-ascii?Q?HlDHBgoAMd/ryCLmWkv5oZY0HUrnIkHKq8Sgd7Drn1ApaoyrVSsP0Tz2y1gI?=
 =?us-ascii?Q?gItG3LgIQ9HwBroJL5UvhXgiG4DSzOn8KNH2hEcGieotLkeQ91CA+44W7xPX?=
 =?us-ascii?Q?YlHLeEaUotheRwL3WrkqWPg82j21mExSRYxoHZOxVH9DEmXVgaZqRGYX3KRs?=
 =?us-ascii?Q?eR779jrWIPcnUpF3T2N5EXOCxakNLj2v1xmAcSUEJxgXCxwgcEiBrVBqhgsT?=
 =?us-ascii?Q?hS9XlmX3xewb42EOwVM0D4nvp0MiV5DLYJvnZ2XM1MbuzDrVthUu8L4FfWzT?=
 =?us-ascii?Q?F29Ag0Yq/U521fSqNkRSq3Kp/3KtH+HEfkwQkbbiAnmfcAFSphe71GGbFuvc?=
 =?us-ascii?Q?AUNn9BNmyVUSStQMTaY0mKUE6swHB5vR6AQaQina4AZ9eEgChJVCpe2cndBk?=
 =?us-ascii?Q?xVu5C1UNhqJUx/najdbhjgKo33Oy7x0jb75N1ogDVp+ICcHJCQ6pfM23EFAT?=
 =?us-ascii?Q?W3xQ3TVxAJnWZsMX20rLtnTAt0D+4PmHJtZUl2R9eA4fzEWs+HXYhKhGNZc3?=
 =?us-ascii?Q?GUp9H1Ii/wzBUWV8y0e7nT9D57+QPD2vtmrN6Ni3MRhR1rnLlIw9cI+0Rcrk?=
 =?us-ascii?Q?TP4jjM81m57inkqn+M7uo9hrGDwLUEVn5xPdsZVqcTIBdG2NGrtGcJ/TC0HX?=
 =?us-ascii?Q?pJKx1kg5i2jc3LdyTK9FfBhQmTnqk46TvUOh0JcemFO1cYG6BzgPQ8/zo6r/?=
 =?us-ascii?Q?A7QFyaJ4u8I1zpOzPTDcUboaVHOaCluPLlMcSIVhTfk7Az7xZ31+ZMA5E/Zn?=
 =?us-ascii?Q?k8GCpEXIIlgCpeF9hf853YULkxauPL+r6hfSkdqtTY3UvSi2azbVe9SOepa6?=
 =?us-ascii?Q?NqP7eqcW/Tui7kDQ70FWJksiqkZSJfgdwMxtvGeQ0ANls4AicQH9wY/CWTv4?=
 =?us-ascii?Q?0kzg6kwoxswk/5p+L2bNGJeG0HbUT/A7b/PQEXOlql3vAuCMYI+d9+90B4dr?=
 =?us-ascii?Q?c6umYHHYOFefkdyo3OBVw8BSUQDqyY7bTCNIBvjhP/H6gslfnq22GlH88SNO?=
 =?us-ascii?Q?eGoQlLnFs+i1dFklkAjhuGm4JQ/jT085JcXduoKQ2yg1qLxEO3bVqJENOmqJ?=
 =?us-ascii?Q?tjMeR13o7xOFdfRXZfDH/uSdcUveLK99dfXWocCPVAUpKC2uY30Z9V7QLi4+?=
 =?us-ascii?Q?bZvShfw00XcUPkKu4cItslV2sY9aj8GQ4kzsJtdrZBi/6oyHWw1mynuB4MYy?=
 =?us-ascii?Q?RECBZ0Pcmcj6l5vkOZfdf4FF3t7SmaInifyynEF37AfTYhVka1b2EHl9sjIQ?=
 =?us-ascii?Q?3NEDGStferF47VE4UfD1Uxxo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0PWbWbrDdsWblJYAMaNiDJIJ8MdTU4t7rRSb+6yWQsEYzulw2AriDAFRTqwY?=
 =?us-ascii?Q?vVR8810+5IedpnFFZ+xaA10uovuMGn4yKKF9KaF/pcydhp2joEFeEgzksqJk?=
 =?us-ascii?Q?ysoGCvEXzWoKZfWgK9pu1Ro3CbYeZfFJrodHuEBB+jswcckFVcR+tMCHltrk?=
 =?us-ascii?Q?GSRqzidzTSjl/Z4QYf0vUxvgvsZ2h/U12CpKTOz943uj+FOQ8FdNeHWdCIsj?=
 =?us-ascii?Q?I1it0HkvPoPSqShuIfqtXH798pItllRalZFaADNscUx6uSfBKNKKRM8nAloj?=
 =?us-ascii?Q?hcZEy6JkZjddHfuSNardEyo9myX9VNpVl3r4oS7P2zpHsOTiVs1zXCH4PnVK?=
 =?us-ascii?Q?8mH9fBW98O5y2OKa/mIpbhnIYBDn/KGGE0cYf2RiWImXQ2hgMIXjVIebWwNm?=
 =?us-ascii?Q?/d/beMKAcRWZ8pLA15Hiyn6AJGxjMX/BAoBf6QF5LhisJd4SXypYSRTqUiIZ?=
 =?us-ascii?Q?qoW8IZkyMl8flpeKloTBtOuidgBUBG9vEw9893tO5ExhqyvFYyQYg5oNRGrp?=
 =?us-ascii?Q?3WUxnl2m/ICxx6o1jdD6LMh5yWWJg1jTa9Jwgjun9Uf4CfqY8X9NA47XebGr?=
 =?us-ascii?Q?B9ZbfG7aC2PIuPDCYgkkT5tEnwfm1wwA2JXULIedaFKL4epnrXQiJfUA6LhX?=
 =?us-ascii?Q?Ez4Ig8MS78ZwjdzFMTvJWxf7uA4VlVbY1L9jioc9ghH6IPYUd5rh4OpcLdxl?=
 =?us-ascii?Q?TRDu7WuEfZzNnuQW6DE+hej522aQ2ewl7w20/7DyckCOXS4BVzwUPzIN66hv?=
 =?us-ascii?Q?zUqyfGqpNzmaHDpg984MwKRlzfjORnMANAysxCikkg3KGgbdFd+NfyA4dUwm?=
 =?us-ascii?Q?plPuIoOLfM7vyG6LuDRXwK7esQvfqTDEFO5gp9LkW4qGy/8N+CHFjShaFxIZ?=
 =?us-ascii?Q?yY360v23mxm1C9IOtzNlpOBLb7jsR77US8KjM7K/AfAoPpH7ZddbbBnE8IzY?=
 =?us-ascii?Q?tJcKtjt+RjXImJ5W10tFKVBWYpqzk41P/PPsYnW4N8rAL3wnYtoL9g+e0w1S?=
 =?us-ascii?Q?WkPBKDRucZ+E4ikGaymydDrf6/5j6fjtsIpLNZX7WGRfO5FA4A0Gl3QkE1tF?=
 =?us-ascii?Q?Nvw2Jq3nkfk9jx6g+P/vg3+NkC+H8dQz0gi9kIhbCl6SHRaxb9Nk2mtktZGq?=
 =?us-ascii?Q?T3PqEkY9odeHjMZyymGxbE6wdpHAi4vG4FDviNbCdYK09aEtY2iNebOUIiY8?=
 =?us-ascii?Q?oQsmAUdqSP8wcWX4QvBZEdgIc5g4M8TWjRz3TBECMz0VzCZRXkyJuM4JHUBV?=
 =?us-ascii?Q?DRPZ0fPvDnJIuHiVUuPBJwv8jMksBEakSHk8OsF4bXHdP5jrpHqwt1k5ntVx?=
 =?us-ascii?Q?8izQT6lhd55rj4IqjLGiX5f3PEP+G+MljymEZthzvTMBQSgX0FysNknt8zsc?=
 =?us-ascii?Q?i7AYV7kvAz5PDJWYxGcNCd+DBKo0wEWXAWAlgSgrjBv7L5IutA5wCFdm/Fwa?=
 =?us-ascii?Q?WnSpVC77a7LTmjO6687mypYKRG03jc/Om4Gp9ODLxK/+qaE2sacNX6wwFKJz?=
 =?us-ascii?Q?RH1FPedAz1v2FMSZFiIF0J5hvwV+r+bdYK8rVocp8P+hbJcsWSKmwaJqvtt6?=
 =?us-ascii?Q?QiaWT13RhmL+rV2IcuZYBrnSzStl/UvvRAvobzHm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e159cbc8-b818-442d-9c6e-08dcefd378d6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2024 00:17:52.5424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luKogzcxqk2ZGowOp2J0CsMee6LEgnbprCja8ueRiEd4mCbyNW2arBahm9eBbnWLyVu6Dd7rH/qKQkMLwSE3cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5884
X-OriginatorOrg: intel.com

Li Zetao wrote:
> Since the debugfs_create_dir() never returns a null pointer, checking
> the return value for a null pointer is redundant, and using IS_ERR is
> safe enough.

Is this change really necessary though?

Ira

> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  drivers/nvdimm/btt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 423dcd190906..4592c86d5eac 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -227,7 +227,7 @@ static void arena_debugfs_init(struct arena_info *a, struct dentry *parent,
>  
>  	snprintf(dirname, 32, "arena%d", idx);
>  	d = debugfs_create_dir(dirname, parent);
> -	if (IS_ERR_OR_NULL(d))
> +	if (IS_ERR(d))
>  		return;
>  	a->debugfs_dir = d;
>  
> @@ -1703,7 +1703,7 @@ static int __init nd_btt_init(void)
>  	int rc = 0;
>  
>  	debugfs_root = debugfs_create_dir("btt", NULL);
> -	if (IS_ERR_OR_NULL(debugfs_root))
> +	if (IS_ERR(debugfs_root))
>  		rc = -ENXIO;
>  
>  	return rc;
> -- 
> 2.34.1
> 


