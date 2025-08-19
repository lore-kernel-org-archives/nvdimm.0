Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724731FBCA1
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618978; cv=fail; b=HoeQ4nHvRNG14EL0d6eoEg70GPvWQtspnG0CNBTIyaLXDDVbFOoQJPOdclbGdk9JVJgvrCRvbGzGOn5G+27xS9TATH4Dd3FZP/K/MuclrOvfnFvFEYkHxd/BhycgQvyRqhpievnPZ1U28skmq4FwGdOmFCTKmC03Ls+Wy3V+nL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618978; c=relaxed/simple;
	bh=07SMzJpGEqFPPh1gQySCaN+86FgNOyvm1OtogqCBOGM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u9N5zNSZmVs/qDWg/NOLqXfhT/fejukQI+wPpco9BKrwDAaOmCn8QbxwNYRwj1OOzhztBbxnTLtFnm6hVtvkVYTNCQtJYXydT3RszJ8ykNsXiVbdZPEn6KbD2d3kK+c+D+hUxZPJRSb7aYve5U8FpUI5zTxFCFudWc779XIjkcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mz83XHBW; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mz83XHBW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755618976; x=1787154976;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=07SMzJpGEqFPPh1gQySCaN+86FgNOyvm1OtogqCBOGM=;
  b=mz83XHBWoDF+znl9k/gOeK4XjJeFxH+v10KpvXyMpEcPSIqIL5xRON2R
   +tTFvW0QYCw5BQNUkNXYvfnlSACEf3BHZKuvwfiWb7Y6rsIJUOlXVq1Qr
   nr+MshEIGFd4sn8Gx5T3/Tf73tI7BgNMqq1SjF3PHuI+QbLEH2yfaJk1N
   aS7DWuN0jP5p1rRHoDUDDaFxbXpOs3YxcOU3rAri/kJU+4Q847ME1O0qr
   XRZ3pMleIrsf+MlEgPHtxu/2OvCCJf4qdOQGt38wuX+y5grTmKyy3GwZ2
   IvclIwRbkwyqNTtvXai0NIaeHhPoXSEwS8IgwikQpb3PJpqjQhZ2hF/54
   g==;
X-CSE-ConnectionGUID: u1JSYJdDRTyagBPj3sf0qw==
X-CSE-MsgGUID: eiyMwpZ+RQiyWXuEvepnig==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57723708"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57723708"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:56:16 -0700
X-CSE-ConnectionGUID: 1G3tLiIqS52psf58cScxQA==
X-CSE-MsgGUID: n1KzGGI0QSOMT/mnr8r/ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167061470"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:56:16 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:56:15 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 08:56:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.64)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:56:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMmUnafZnGSyM9XeTNsF2dfALx2NtcAI0SddKO4GuXUHLu7+tTZs9aNHhlc4nOFu/5c+s0mFU6ZZK3Xizuf5m/BFWuJ8mUz+Da0c9+vUT4dz/KHIe964BDkUKTgGDmhaJjpPml8ZUlk3/Pgf+7nn7d+mCGBsCOOi4Vad4pCol1HTmPpFiTwAWGj2+cAHDEb8F/UYkS1w5FfRPvUnIPEnFrJpEXY/C9MYTJNh4v4UCGJo/4D0P9dyOZmIZMc9YAYaysj61wmiudg4XhCV03QuDn8nCr379rokMi4LxW8mfQiOEzaowcR9vdRGdAx1tVuFfMU+HcuspzTkKxZNYJL0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlMxpbXIsNzF5oA8noGbGGYARK2GNQQxgFTpmIwvWsM=;
 b=ds2l/HQ/CKKfxJcd1TNdog1iXaghFpHEjwXsWCWAUzJBDx/MhfwNVBYXnXIWe9mta9qdM7CXmV1NB8VDeTyJ3tCxDlqZfC5xTvkRuVdMPtSdYXNZM5GjaDYNgO/rAvN0Uq6vogMGAbu70w7BZ4VncCNKSZT+gFao1Qh5N++cZBzz2WxFI3/WvDWWvVrdEweVH/pFpG6xX67HVc2sa5jZwuXKFTuIibeLUiiKmko4tAlCxvrx4/QJQ6OFhRNwBDkaOo0juiPngpUJuT8uZu5zlb7exzBQBNkr09jHeLoxleyDDwxp3bitjYROndue1HkpZSAAWHxyg2Ua9pZyH8GVZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW4PR11MB6569.namprd11.prod.outlook.com
 (2603:10b6:303:1e1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Tue, 19 Aug
 2025 15:56:13 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 15:56:12 +0000
Date: Tue, 19 Aug 2025 10:57:57 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <68a49f05796ef_27db95294cf@iweiny-mobl.notmuch>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19@epcas5p2.samsung.com>
 <20250730121209.303202-4-s.neeraj@samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-4-s.neeraj@samsung.com>
X-ClientProxiedBy: MW2PR16CA0006.namprd16.prod.outlook.com (2603:10b6:907::19)
 To PH3PPF9E162731D.namprd11.prod.outlook.com (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW4PR11MB6569:EE_
X-MS-Office365-Filtering-Correlation-Id: 16d1ee96-4f46-48ee-6bcd-08dddf38ebe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?i850KWtYFYWGkgMXU+E+Z1KTCfeA1RzEh4/DPudyrOSWcPZef/gAt1hqnzPO?=
 =?us-ascii?Q?bBe63kVPE6QiWjdjqooTO0lDNhadojJmyQv98gCvVMKU4SqoNsINtDRyX3np?=
 =?us-ascii?Q?Useso+xARTclDQhnW7FhxtDz0SPCVXBODQhbLsTQhPE28TfYjUXrHSAHdjj4?=
 =?us-ascii?Q?GSzQXwTMXL4HAB3rYcTcXzQJpB3HQ3fG4zmDy1Z+V7UagH7PccHgtn/81oCB?=
 =?us-ascii?Q?lFFOqHs8OrdqyGQY8wnFUq05Tq7/xrFxOgKARyUAeYhqm97N9dFoZ1pdH9+F?=
 =?us-ascii?Q?c9IG/kjlzE3fwGSnfDxXNJA+VkDFKAu98HWm6lw3+XK5Q9gqHxv20ws88NKa?=
 =?us-ascii?Q?54pnnPUrDwuOWFAwupQtBaXtj7RS0h6+tFqx4IRo1tZqmd8vtZUdp0rl7WhJ?=
 =?us-ascii?Q?7k5E505jSlU845BL0qjYj9U0d26NVd0XRaTnZjuTWtZ5H/VFY3FZZfoWEbUQ?=
 =?us-ascii?Q?hh3hUfjZETaawSZNCATRCok3TcvAsJ5nRk0l5BaLEu0KRLj6I9FOoBBydT7b?=
 =?us-ascii?Q?/qjTBYSmAVLnkTUNUDEKtwDt/sN6hfQHXyNqJiseglFVdasWUawerA31mTKK?=
 =?us-ascii?Q?a+Lr5UXqZDRLPTwOBL0hedicIXe/orseRAwiVHVZBYWT91NrEYgPQ2eCF8ox?=
 =?us-ascii?Q?CI5V7cwS65SCGU9Ya6QLT99W9ACb280cCVxIJ08Z6amz6K16SqDxLK+YHTVb?=
 =?us-ascii?Q?sNvBhybOUSXzNffcY6Eskf3CwReRGbMy7tfPBans2D5hiDKPrHXNN1w5eKKY?=
 =?us-ascii?Q?wR2MZyGUbh3wQ14Fa1T7Q8RqrsntlQ/xVkowLokhugdfJEC/WzJYwZSzHmGn?=
 =?us-ascii?Q?gAieh0YdV8NZrwgmOqEOE1Tca5EXEkoBE6hIsVeO1HAObPQ/NFtmpHOYuLou?=
 =?us-ascii?Q?jaWN2jiHjUtHh20gZ+tuTLgmdVKQkg74RHt9onEq88/jQYVNEbo6Z1wrRV5k?=
 =?us-ascii?Q?NnZhDXexlquvNVocgfWjVD+4t29fp/thWlliEGXjgZOl1D4R/XOvIyBqoVtr?=
 =?us-ascii?Q?RFz8LV3IL9jI5suyHIP/eMveqxXFvj6O0Bi4RyTd+G1sM4ySpsi/Tyc3gZMr?=
 =?us-ascii?Q?oIU9WMt0tS8p50rc85DtlsmQZJn4qkfVzc1jkso4XGtdAcSswirAxeiojAYW?=
 =?us-ascii?Q?thKPacuoio1ZK8ufwjTW3VIWRaAlywDevyPBmqhWtp05nMEqCymcDO38Bqfw?=
 =?us-ascii?Q?bmCINWCsMtQfQE8w5w8QzUcQWr30oMg6IpQpwCQAaA7gj2l87FRaYNHHyqxj?=
 =?us-ascii?Q?t+zKWekQwzxqxDqw++t3Pf9Ej73UZ1mxetZ9IDGH2JuUUu0yxWwIVTRdgAdF?=
 =?us-ascii?Q?vg/ekEp0mZrCim1eKSE4rBxqISgzEWkytItNev+AYWB1Nmc1GxZAEh0wSRpd?=
 =?us-ascii?Q?LWBeqTo1BLWwBNsrj95PSYviLSsIFLU6XQUpFClt4ylzFhdiUg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YuTQkHA0PemWiV1sMuOHzGnJA+2r4rwgaAllJUSWBbVx1tcBVariTyuvfXvQ?=
 =?us-ascii?Q?AA/aMlAFrG9JnloHwbB8NlF+Edywwtdgo3+6nBSfmuMRvtFIfN/7rhoCxlAd?=
 =?us-ascii?Q?fwDT1ft0tIk5Up3daUuOk/i4EkaXKxJfCNt54jx621Tb7xbNgTvPh7V8H0Q/?=
 =?us-ascii?Q?RSbmBTe+D2QZ3vQyUf9NiBon2XXrg5+rIGByq//FfUB7EbYAFg6ppPJLGw36?=
 =?us-ascii?Q?9lYKVneEUFwmUeRGbkuiQIwL7zYDYpfYDCtDh7hSg8E+DfFxC0S5kQPwvpii?=
 =?us-ascii?Q?sUORbhjnycFLwy61BD458fPqtMyrw/er+qMnihlCVg07uNLvletF7lg2+zdw?=
 =?us-ascii?Q?qQNi1ZSKrS+SCFiyEycKzRUePdrKqGQpOTVlgrACGSAm6eo2u6J+ceY9ig5H?=
 =?us-ascii?Q?PMTvLbCywpouvaRmXFiPI5wzgZY17g1TRmktKG/gDanGJLupsEW8zeZHLnTY?=
 =?us-ascii?Q?uLQQetxyPZMfFprjVT8qYu+mza+0gm45Mu9BDAU8K2vVr6BCs4SUAJ0B8yK8?=
 =?us-ascii?Q?sYHg7hMCZDRyVgPz8m4tAb98osjxr649I8qtWzdxpxPecYQ2B72IwlfFyxL9?=
 =?us-ascii?Q?8+3dmKHgVFnwSy9SOm1asB1Pxaz57Qs0NZqcOdIVr8QYUionSdv/Xp++qogA?=
 =?us-ascii?Q?IoJCfN2ededois7qNcKrGeh9y42vRe51MGooM6MIrVTHcv9PB6+iNO06y0aQ?=
 =?us-ascii?Q?TW2RL3tJKx9uK3Ps7B1gHR6rnW0fqROFuziN+sEckaz6F55LGa9pWsVUUYZb?=
 =?us-ascii?Q?8xGwYjikR97qKv/hPirUSa5MTij/Jt6lu4gPm7EsBJnAPvMi9g3tWICZGMRN?=
 =?us-ascii?Q?G/MlXWL5Z6GKwr2VFVUz3Ldr4i8umGEY94NjFtnfTX6WrioLjyF+Zr654Nbt?=
 =?us-ascii?Q?g/NWlP/j6peg9VnUyk0EwievjgoRxtQINwCtwaYqSv8IVJ4WlU97IU1E54UK?=
 =?us-ascii?Q?We2pkUz09ldHLaxMf0dZk3q/s7vE5zSTaCRS4D65IwPXwzlw9HRmb030pxYC?=
 =?us-ascii?Q?2vQifjabRE/2Q1gGuHFsnbKkmuUI6aSwlyoHZXOA20LMfNvVN4XRSAPRtide?=
 =?us-ascii?Q?dvOMGGhCZjDcs0vWldAlYFZryPg5Q36Ee/dbCX5nkyLM75MK4qZiUhL8IHcR?=
 =?us-ascii?Q?3R+mOuElu1yVyc2XUyhHf5dXGCh8TOaaTUgGvjTCw9l1RwS2ocs/sM1mgHpP?=
 =?us-ascii?Q?meNWxZJkTkCpV7JRdImabpqP2otgsic0xsmxl+LqiNpKphfOjelKQuIxy2WH?=
 =?us-ascii?Q?jBkpNFhk/wfLSBaH13YnxkLoqId/DwzajSVd1OxG4vVXEsuGPTeMQd3F7P5e?=
 =?us-ascii?Q?oHHVqd4w2JtOC4FTyDpZF95mBY2hQxC9YTAdUlMZ2jgfOMisTbMVOURMp9MK?=
 =?us-ascii?Q?wcnU1987ULPFAaNPj3lm7jDnFbXI+tvi9wdzn//YbJg03YCCrSHcegDJLzvI?=
 =?us-ascii?Q?0LGl4Nk6EVlRVWKoFHm5bj7W5VlYy+nceuD//1SJVC/qgPGhDyZDrGgwQrGw?=
 =?us-ascii?Q?1Bj8EDz1zJvt5UH377Gry6xNX0sCsvHxUNSfciN5OI1g+8+GP26CoU5eOM7G?=
 =?us-ascii?Q?02ByCrn6JYSfaCCqSdW4sTnS2kflQT4ZlrdzmAC8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d1ee96-4f46-48ee-6bcd-08dddf38ebe8
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 15:56:12.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQgBX6LyxVSjkB71751isBdlisnHbEj8+craS6akumTdY3/8CLjMxzFuHesZWrs1Med0lKsqCz/AyM6YggqRRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6569
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update function using setter functions to update
> namespace label as per CXL LSA 2.1

But why?  And didn't we just remove nd_namespace_label in patch 2?

Why are we now defining accessor functions for it?

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c |  3 +++
>  drivers/nvdimm/nd.h    | 27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 75bc11da4c11..3f8a6bdb77c7 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -933,6 +933,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	memset(lsa_label, 0, sizeof_namespace_label(ndd));
>  
>  	nd_label = &lsa_label->ns_label;
> +	nsl_set_type(ndd, nd_label);
>  	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>  	nsl_set_flags(ndd, nd_label, flags);
> @@ -944,7 +945,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
>  	nsl_set_dpa(ndd, nd_label, res->start);
>  	nsl_set_slot(ndd, nd_label, slot);
> +	nsl_set_alignment(ndd, nd_label, 0);
>  	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
> +	nsl_set_region_uuid(ndd, nd_label, NULL);
>  	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
>  	nsl_calculate_checksum(ndd, nd_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 61348dee687d..651847f1bbf9 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -295,6 +295,33 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
>  	return nd_label->efi.uuid;
>  }
>  
> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
> +				struct nd_namespace_label *ns_label)

Set type to what?

Why is driver data passed here?

This reads as an accessor function for some sort of label class but seems
to do some back checking into ndd to set the uuid of the label?

At a minimum this should be *_set_uuid(..., uuid_t uuid)  But I'm not
following this chunk of changes so don't just change it without more
explaination.

> +{
> +	uuid_t tmp;
> +
> +	if (ndd->cxl) {
> +		uuid_parse(CXL_NAMESPACE_UUID, &tmp);
> +		export_uuid(ns_label->cxl.type, &tmp);
> +	}
> +}
> +
> +static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
> +				     struct nd_namespace_label *ns_label,
> +				     u32 align)

Why is this needed?

> +{
> +	if (ndd->cxl)
> +		ns_label->cxl.align = __cpu_to_le16(align);
> +}
> +
> +static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
> +				       struct nd_namespace_label *ns_label,
> +				       const uuid_t *uuid)

Again why?

> +{
> +	if (ndd->cxl)
> +		export_uuid(ns_label->cxl.region_uuid, uuid);

export does a memcpy() and you are passing it NULL.  Is that safe?

Ira

[snip]
