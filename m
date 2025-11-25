Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12EC1487E9
	for <nvdimm@lists.linux.dev>; Tue, 25 Nov 2025 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764088562; cv=fail; b=fg+RV1m/+2hXcJXQgLVcYJflG4yJHFi9g9PfiikUFGX/InP1/QfBKtXVydY62p447zSd3rBJuxu7BnPxooRfJRfh28yxJAKvGdbka9s2U6Fcz3LLWdUsAMiPEGGla1kIyNd0mJtk5texwYsAljmJTuJjvLT7tssJZ9j//D8biBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764088562; c=relaxed/simple;
	bh=Z9jLvCtjZH5wsm01OR8NeNhla8u6ttgcsWAmE3HKlhI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Uq0iELmEBNYr0oDE1jyUK3vKpZKGjfbVspcurVicn0viHT5qv/sVmGADQk7aBqlMZ1cmI2wjhpRB1MId+F++TQRtszIkyol/R/MyWRKVrxB9DP4DWmnZ+p76/423NtV/8E2aiMYMyBP6a2VfdEUIJhxxf5nn+Aqf5kK9fqk4Sns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z9v2/O4v; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z9v2/O4v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764088561; x=1795624561;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z9jLvCtjZH5wsm01OR8NeNhla8u6ttgcsWAmE3HKlhI=;
  b=Z9v2/O4v6B1YHKf2cpt4+M6sMKYqOmJswmgCXqXl8Hn8LZZpyLXQdYfH
   1AmSiw6omMgWVcEzPinaWu+kNV9zMadnQ/EBslAlvuz+OqYokyQQ8nPy4
   F45k7ftzjeVq1WKD6eCrFgS68Dof+2cmDQNS+NlI2B3hjQi/kw0FYQAoH
   N+BZCQ6wGZnlgHWOLdUdS0CXNQKvp7ZtR94QjWewYoGy7egRF8n88LnxC
   OwDyQH+697LW2SqkBgpL5yal+1sS/LhJuWQ7Ha0DNWTH8r/QstcYrDtCY
   e36+ODMkRa0GIUjyGCuck1ABjjnFAMseixAG/9SiKp5ikL6NTO8UOGwEF
   Q==;
X-CSE-ConnectionGUID: Kxjd6yplTceR8JUqAA19kA==
X-CSE-MsgGUID: cWss+Hx8SUi0hQSR6NdgkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="76437356"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="76437356"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 08:36:01 -0800
X-CSE-ConnectionGUID: bVdbXiU8SqCZuYy/1M0xpw==
X-CSE-MsgGUID: 1LcxylfgTpamF1yI4n1TKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="192481819"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 08:36:00 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 08:35:59 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 08:35:59 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.50) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 08:35:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KuNCFJdu9tUtyHc3FXGIoHWnk/z4/+xvt1qzlgsr9k30P4x34UHw3mSO3Bk2mknvw7Ad1h5j4dy5Up9q0kTaKXRjnlnNSL8XoLjwTW7ET3+wpLRUu7LbYM/GKyd56V4JMopdgvjunz2A7WyDpepVUXvKuUru+qVZ5dkdWYT0XjxHkKja9kAtqhQnpMQkt4uh82PhAiasO/jUogNL/LmET2YerONFpiMrVQVZ8/CsE/zHnHeaosX8K9UGRlVQCCgDBuMHUjlSbeo0r2/N1KZjRruaMUAfVa1eEvYNFq2HglGyK3Ewmj2jnZpGHui1h4suJCYP14rouskyyFzhfm/NdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNIv9J3qKsjNgn/UZ3ou02nwr6NCofCVhA7/jlWx9lU=;
 b=WkkI9TSBGbrDwtJd34PavZQTul4aq+2BfrcSZddEpHzLDVBKvgRGlUBktEjVQnb5yW9fg+IXO8a07SYlVoVlxxllpS9KgsQlMCIXKZKjJTL18s8876gzHz2RK2WyoBXKQlv/D9z/iaNtshg5U24kAwX+5mTo4cObaVcYKz+Vufvi1S0urWiQpp7GkfBTRiSHl/2qs4dFn9bj/MWmuRiVnAmGpTs7uHNA2keSL9OCaxdM3I4Ls3z2aZCmKi5deDC311WNLyicIv6xt+UMOM444pwhI1a8MSMFNi6xXyubOfFz0ivW8ETvJhMUPkD8jgsjy7/oz6zFFLZOFynAjxs2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA4PR11MB8892.namprd11.prod.outlook.com
 (2603:10b6:208:55c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 16:35:57 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 16:35:56 +0000
Date: Tue, 25 Nov 2025 10:38:29 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>, Mike Rapoport <rppt@kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH next] nvdimm: Prevent integer overflow in
 ramdax_get_config_data()
Message-ID: <6925db85a9343_63977100fd@iweiny-mobl.notmuch>
References: <aSW0-9cJcTMTynTj@stanley.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSW0-9cJcTMTynTj@stanley.mountain>
X-ClientProxiedBy: BY5PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:180::20) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA4PR11MB8892:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f304865-5308-49b2-dad9-08de2c40b511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k8yMPs8Gj96UB8T/O9+f+xoPF0zlbrCvFF0mlvRmYJdLQNIu6QQ2qmKPZvN9?=
 =?us-ascii?Q?vS34Wn4YRjcrhKV08XUIyPeN82y9njC87O7w2HQ3VrF3E1op+uMxcEEQz8tP?=
 =?us-ascii?Q?fG4Ws2CcoDh2rd6y9LEUck2wFhC0pf/tL8V4/vkAieEoY0W6DKQcP4W+XU0p?=
 =?us-ascii?Q?8xqupOH6RDsG3PtMnOCIUJvFDYD2x5h8WKjs6c3qEqihPW1EPmFGgRebojcG?=
 =?us-ascii?Q?1uhxuJ1uzc8qHhTnZNstCFBQ8KRGDXLvf5IDCsm+Ju4j0lhM35jag107mF11?=
 =?us-ascii?Q?cf8jRIbHiY2MYv4/xoWbtddtl2/edQLmTuzWXyWkLLRxaY7/OnzRTvBhsG7g?=
 =?us-ascii?Q?XK8P917r0J0B6b39owcCoKwwfIhcRaTwY7d/wfIovzq52jKR0mM80Q79OSqw?=
 =?us-ascii?Q?a+0m5N+/x/2YpGbQBVeN8nQ33S/YRFFQBJ68Zf8EpKScMDkp28dyLXSF9CvB?=
 =?us-ascii?Q?aQeULICB1iBsbZROfu9osts0nIP3qTqhvY2LEzoWWmh6jDkQ6sjcxsPMGiZY?=
 =?us-ascii?Q?uSJxPTE5nMa5maVjjev+QworTjnrQIDIrSpzN1I7EvHaIAzng1M47N0RaBcM?=
 =?us-ascii?Q?1oPLTUYGat0qXJIryUbX+cIfl60RNj6wMLrJtp7PwhjaPJ8IyVc39EWxluFJ?=
 =?us-ascii?Q?VhroJpjqX0rkt5X2z+rCj8n2gnZ4/zVRkLp0B0mjbmt9sxd+19wf3Tm0OM2N?=
 =?us-ascii?Q?0vG9Oi8qxJKddoWLk9Iwj5y7xxBO9aWwcC59sb/RribrFlHvg7zTpbvssAPr?=
 =?us-ascii?Q?6+JfHNij2fIeykrDMhxIsbpzjaDtBH1OgZ0X+YgrCVraqfGdUMhTan/cvk3j?=
 =?us-ascii?Q?8FX2mmfGMQtGyWek8EC9G16QWiOp1VcbQ14n5EbNWbBDkV7YrwS0xPMQG4KY?=
 =?us-ascii?Q?8ryn7eNFJbM1sSWgjfILGof/9PalA4jNUfgOu+A6YUlRUzR6imLCbfrhfBdd?=
 =?us-ascii?Q?77dcsoZbjasEf6j84d0lc/gwN9iaFLajU+7NK8nJFzIfcZ0NF7KzrbTQPUrH?=
 =?us-ascii?Q?461GseGihnWvbNzOL23qXhDzYxM3pCpHu9bYuiKRVU5KlgwU5+mUenfHVdX5?=
 =?us-ascii?Q?Kh7Jvwi4Sag8LkEzfZQ4KdR3H8vNkAF7pfXtqvF4Jh62Dh6tVe5/qBEIeDgc?=
 =?us-ascii?Q?V3ozGNzeCH77idV2Fu4t8xsjdm09NqDhIADyiwcp30Mmek+XzNhHOXsldmSH?=
 =?us-ascii?Q?M/oL3JA223Wc3x9aiwUmeS3Zneo5CvAIgBHKyqsXrEZDGRIiwddLMUeoPHq3?=
 =?us-ascii?Q?EXVWuw4k4AfsvG7aPqQ6iDRSYfAQZltuPPvhlrNMnkrIJVs/p1HhTiKwqHDV?=
 =?us-ascii?Q?3R6Am2hqeKT8ai//7LOdYL8X3zzNlt8km3q2BJJEl+LkgiVhOhgOyr8nbkGg?=
 =?us-ascii?Q?gC93PtHJga4YuzhDpWOSf5uNqZ8QrtnNcs8nH2wJusNmr2loYZ3nBCHIVlJw?=
 =?us-ascii?Q?SECRb+VCUO35tTPHd3dh5vdvBJt0xjFX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a/qBo8W2XDOcHxKgHL63Sv0r9i8hODd7v3mTWsOrQp5sdkb+bzCAaVcGVkDx?=
 =?us-ascii?Q?nqh5D3+GrGBYdJ8gn6bNoJZvSWE+qXnvKpoNZad97jagHQVP7v4Ekq4LgrAE?=
 =?us-ascii?Q?gC9sOJV8PLJbFG3dY9JmERf74xnBlvhz+XkqF759TMtHtooeQZNF420Xp2wI?=
 =?us-ascii?Q?xHh94BwneuF8xAyfMp6gEQD2oZPhEM3xXuT+td3wNd+1mzqSjQK7JSjdIyw3?=
 =?us-ascii?Q?SKUJ1FVX3Kigkx0Jd+2WbDnwTAyTr8sxO1831EXylvyyDTHxuHummyAeHFh4?=
 =?us-ascii?Q?ejZZstNCWCpFAXhAmB5e7HP8hFfyj0xmHXuPZu1RlYVrJ5LZ5X1MaZZexK8b?=
 =?us-ascii?Q?zUAOBWXx++7RbVaa7vu2o82PsDH6YdBrxnyI6uht2BEay3r51Yjbv/8pQ3Hv?=
 =?us-ascii?Q?kJRWKZPGrJBRDbiULWcACCFXxsuRmzbxDJ9B8hoV9drNos7UDI604eS3SP0u?=
 =?us-ascii?Q?LKLEunjOtvjclaRpF7nOBDvBz4C25STTNbJneDvXjfMAchYuHLH6I7AyzsKj?=
 =?us-ascii?Q?BM/cWdPG2PH+ocI829N6jJV17AvnXugEmLi+egHEve2IEBxAdRGraOwuLwQ6?=
 =?us-ascii?Q?OxGslwiOY4KZa0tz1tPzqmlng8wcImG/mnzdQmIlNLybUiF4F98YYUT/NQ4A?=
 =?us-ascii?Q?sgcjVESZknQwd/PEhHwPVI2CSGfmoAkcjcfdXH7YWDJppqicIl/4DAMOxgHL?=
 =?us-ascii?Q?6kfgUvZIyqeHdTDgJkZjBk+l5KOzHznHO0ZGvWjnXdHlUTeFh9VKPHwZGdqa?=
 =?us-ascii?Q?UgV5Y+XjABY8D+sxSlurchtk3Zkfu2ZHPJrOoJedlaEhhmPJnuBP1BY9O3qI?=
 =?us-ascii?Q?znaKfENz+6Ijr6JeEmzRcFWbPIWigpyKLx7C8qxz05pia9R/rdaEwArM1HqE?=
 =?us-ascii?Q?TXt1MPlauylX/5AAxFKNlsv8S9aXU36sEZFp1Siz/zk9Q1G3/Qw4JvO7EdZF?=
 =?us-ascii?Q?aQW9Y+mGCALAkQxX3fpbAnzeht6Y2VuSz7QHwCMeI2heTg5waLmmadYg03PJ?=
 =?us-ascii?Q?s/qQ1gQyEMu1fmmFiPZV44CFQCxHpqITGBFcf8mK52hB3vkOSMNEQlZM3p1F?=
 =?us-ascii?Q?ABwFe7SMsfKg8c+D07JHOxoUz2XICGVhhc7huhLE4fOopCQbGEpOQI78+fhN?=
 =?us-ascii?Q?Fstj673o7DV4M+ExBjCfFoqyUX3Zr2M8Y735/j3BkJ9u7SWYNc4W5UToCIOa?=
 =?us-ascii?Q?Vvc8iVXba/AUK3b6HNO8sqNKjvhEt3CdijUkrWBbFk4IShCIHmbB3pqWcKp2?=
 =?us-ascii?Q?A199HE1JDdRKJx1aGpoqfsm8oo5Q1J7ZubM59velHa7Z+H8H3kSbZxwqTN+N?=
 =?us-ascii?Q?EYJ/cN+w5b6uzHMWrcoG1qN3d9VjUJ6n4DgJT/zA+/gzB5UxPAzfar5deYTp?=
 =?us-ascii?Q?lHIAWRcSGD2Bd5ZdZrBdrraoKW4a9qxUCP2VOLyseSolIYEoxVFbxhyB2Qhp?=
 =?us-ascii?Q?P2AC5RumrcXTyXKsjM3votwKlngpwjA7+EX8TXUTkDymsS2B4xI0Bb8k7OCs?=
 =?us-ascii?Q?/4iqAlZzQRUVuh3dkH+GPp3iOoTrkiO8NGpqWyEI3Y5Mj0hZTTaA89KV8oCV?=
 =?us-ascii?Q?1OEN7NFh/xm4qY5qzrtqg1V6sNJfxBYyeflzWaVi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f304865-5308-49b2-dad9-08de2c40b511
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 16:35:56.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gK66XVrrbbOMcxrXxqnAJ4OIweocxfuFWvYS9qW9KZEGJfEAo0P4yM9qWgxzPXvaAd9hkqbOUU6UDDcM1doh9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8892
X-OriginatorOrg: intel.com

Dan Carpenter wrote:
> The "cmd->in_offset" variable comes from the user via the __nd_ioctl()
> function.  The problem is that the "cmd->in_offset + cmd->in_length"
> addition could have an integer wrapping issue if cmd->in_offset is close
> to UINT_MAX .  The "cmd->in_length" variable has been capped, but the
> "cmd->in_offset" variable has not.  Both of these variables are type u32.

Does ramdax_set_config_data() also need this?  I'm not quite following
where in_length is capped so I'm inclined to add size_add in both set and
get.

Ira

> 
> Fixes: 43bc0aa19a21 ("nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/nvdimm/ramdax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
> index 63cf05791829..faa6f3101972 100644
> --- a/drivers/nvdimm/ramdax.c
> +++ b/drivers/nvdimm/ramdax.c
> @@ -143,7 +143,7 @@ static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
>  		return -EINVAL;
>  	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
>  		return -EINVAL;
> -	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> +	if (size_add(cmd->in_offset, cmd->in_length) > LABEL_AREA_SIZE)
>  		return -EINVAL;
>  
>  	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, cmd->in_length);
> -- 
> 2.51.0
> 


