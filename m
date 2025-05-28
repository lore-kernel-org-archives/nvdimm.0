Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E57E210F59
	for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 20:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748465994; cv=fail; b=vGP5JQMhPTPPXgHdpDqVS2lAbqp3vPw17qJlUQubKrEjvAjj6i6kHLUD2ul9TCorTklacXGSBSDdVz7zW9HIyHecnm6h2XIO/EHcPTSABbzQaDN6myu0t2f3vTx7BYPTbtsJfVkps2goNjcE6MqepoaWy5mOWSQCE3wdUf/g1tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748465994; c=relaxed/simple;
	bh=7+4CXawIFrGf+LRwq7NSXUsZ+uE0SyuQiViaBijzttQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ik+UCYvfKRT9iuZCKeouQK+v66K4HZM+AW8YmPlnIBDm7P2DcgU7YlIASxqkE7ytq/JDiObjRRoAPIt2LDe/egtPYcYahm658L+jw0/djTvgHf+hWBowmduqvlcBG16gLkbrR4AJtm0FWJ+8knoN3TICToy4r/dxJsqaAtTKawM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nmnajxxr; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nmnajxxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748465993; x=1780001993;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7+4CXawIFrGf+LRwq7NSXUsZ+uE0SyuQiViaBijzttQ=;
  b=NmnajxxrHIZ4DTruaSXe7RFJ0FSRuqQkkLNJXT3stCBYVm9nk/kgisdf
   t5M9BLX24Bk32+ppZ63kb6V3zx7cyP8xVR+f9oNM5dmYFoCNxS//SK5/M
   uzd2Ielcj6ElaJYEj32MUwMHxKxZ8yqRpazlOk/7sAxkHwJGdSpSiWNQB
   AlNhegeioCHP5WFIDhtDIS0F1g+sSuc/nmUGOW24AUtuc+qwlXcwdwXaD
   dLYYVO3neCyazYGhv7d30BlLtPWIgzz03MCZOO0HquWwdn0jV1VF9IWCn
   pHf/mhiqr5so7ikxV+1DxBg96+crlWcIPQdT9DS6hJxWSedF37/j5u+Wt
   A==;
X-CSE-ConnectionGUID: FYJmTN2ZQXGZIe4+rA/AQg==
X-CSE-MsgGUID: KHWrAJ0zQYmnI7qxkflHkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="61169763"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="61169763"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 13:59:53 -0700
X-CSE-ConnectionGUID: dzECJbphSyG7L6XcPWm1FA==
X-CSE-MsgGUID: 6UOrOXKeSWKb5mp90HFGBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="143262535"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 13:59:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 28 May 2025 13:59:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 28 May 2025 13:59:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.51)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 28 May 2025 13:59:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUfMnvgPxwzqq6y0oDrXfs/eTvVB2xtv4ef7dMpij6YDjRO4Zhs1tUh9WZoF5eoiO7ABWWFQBiZD0hEEFrRYfOkBLQjBirKHzEkJNFYYavyjJbYGxou6k1usUJ5iETdMoJ5/dQg53I27X82DC3JK1wqUQB/TBzLqvTwIViqC9X/eTwYK1rfEEaZVzsGWoseqNDPRAz+4BKuGelOtsJdG3hghZS+PxUnyfXeVexLSAEVpbsstJde8IRk6AymIZRvdyaBv6rRG7mW1INy0bk3/0wn6c2wftQbZl+UoqbD0ggvQmxmfIBuslyOoKThEHLFFEpqSoLJMQ7RAk8B6l9Aoqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jb/ngHDaqY5bdtboSfqaBatq8hrPEsi+RY8pvfLUeUs=;
 b=CfZd0M1LPNAygA3WNhiAaDbOhWJ4957OFKRGFRBAa1ZbrjNVxwMHRc7hYNQuZZXxtFG7RT8m7SScsWIzcQWNBwW/2tQ5fPFw9OmaSSgD944GpSBYrViJtFmBBSvydud9S8oemfhfZf7BDqAsSjHpFmR3p9Do4vyBcDXzB0lJESlw6AZbO7373WNm1MbIRGCpQgx5Fvw8KEZocvn/MMN18I3ZDUiQdQ6t0+QxvAKcAQYvNSncM0MkttnGwABc2CYABNG4tjwy98U7a/fcIqYrORHHxmG2UuBbSp/22NntiFi3ygfb7GlytWSEKtSltJ+GY34hA026RBf0gnX5ubUW/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SA2PR11MB4971.namprd11.prod.outlook.com (2603:10b6:806:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 28 May
 2025 20:59:49 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8769.025; Wed, 28 May 2025
 20:59:49 +0000
Date: Wed, 28 May 2025 13:59:44 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>
CC: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] test/meson.build: use the default POSIX locale for
 unit tests
Message-ID: <aDd5QLxY1uF0EKxb@aschofie-mobl2.lan>
References: <20250514185707.1452195-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250514185707.1452195-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::8) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SA2PR11MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: b975fcd1-7737-49ff-a4df-08dd9e2a9577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SfQBkjylJAPubtGkrcg3KAcnpacmSvpCaS7OPrKLEOkc2LiLz0OPx2PwdLMt?=
 =?us-ascii?Q?ynO20vRmozxzmAw0qgkFY5ZDuw92OcpO5LitopM5HkPNMrck03jiEviZdYuj?=
 =?us-ascii?Q?f1nIptvRLD63/gkT9VYe7gYfcAaYDtHq7+pKnL1aNK2iMuEpJ33dRmLTd33Z?=
 =?us-ascii?Q?1VKL2SkKjFj/qCEMw40DV2iC5MbpAIU25vntyCbKwTHDJkhDQBYHW600fDsy?=
 =?us-ascii?Q?v+zf/YKCG2GpJyZrQTZ7sKLImZenv4VW2DGPIbzEbCMW2LCkgjRzim4z0ort?=
 =?us-ascii?Q?mUqtiuIrOxuQ+18qxzf+8YuIdp1GgQLPPkSss8BcNT/V3Z69GeHdXoAA4NSj?=
 =?us-ascii?Q?Cp7+FattFUB7WZP7RVACw6glNUBIMxvgzW/2pH9vpu5fOEaLC8LbArNhgFxe?=
 =?us-ascii?Q?Lg1zKEtsWn3du29Tj5IRchckKGqhl+kJ87EivGK7nUsxz9Wul2pcbe/1ONXe?=
 =?us-ascii?Q?gpEatII9KueruC4F1McSNqF6zqmwgHu10uunyz6EAWC0/7KV8vKF2hFSvCUH?=
 =?us-ascii?Q?yiYFwPwf4WVtPeJdj9cQVM/LbUM9X1ChoLfwSpsFndRgKfHWbYgaX5ulCyjx?=
 =?us-ascii?Q?ontrs7MkApMZd6FFBnRBfyaxHH4dAo2NPuJOjtAF2SmfWb1E+mS9/NHpVj9X?=
 =?us-ascii?Q?0396lGouPYDxJFZJhjppZUCvNClP9wAH04yRXXzVGaFIcJqIlJtFOH/qFKYl?=
 =?us-ascii?Q?ZUERKO+4HnJzVdf5Xt9nnXio7h345bcTp5++In5Uv6dPcLwl9/NuWlcBUgj2?=
 =?us-ascii?Q?Au8XBnT4LBourWHvpXcZ2Y6cQ28MWeWI7NuP+ROroxH+3bWPhoaY8rdz9HZ+?=
 =?us-ascii?Q?tVxa4CwRlQIwa6MLaX6b9nuD4ck8glUde9aRo1FPnmQ+IAUjiMfhVtanmCwo?=
 =?us-ascii?Q?qujMvhb8ueTgeohmWvc6T5j7haWL67+YtJ0Nob8GwoaMLOZ7l2U2a11TPvIX?=
 =?us-ascii?Q?yvsHiHjrNR2kjIicSYk6nhYZ1LqTtr7ww4f9oqyq6tjk4ygDqBldy7I6DyLM?=
 =?us-ascii?Q?kiUyoafbCG7uk3TyUP72u2SFJPlnfsp0eaPK3rpcJAqfCbTSzpM8FXqFv5/k?=
 =?us-ascii?Q?V8oJaEuCFy9MLinoTbSHh1/58oI8cXdFMFEPD10CP5TNTRSIsITpkX+91sJR?=
 =?us-ascii?Q?yub/ZZBQ2s+cMnUYoWbcUM6n2BWuvXJ+GXnd8xaieFNEwY1x0kfFlUDYh6xk?=
 =?us-ascii?Q?6WcrnLg1T0aMSLp43lkWGKzUPXUIrIZuNhznLIVpexL1yocB4phtv71UOis9?=
 =?us-ascii?Q?Jktja9nDIRyc1C+VTAzICSw3Cdugssp6Hd8ZqNx7St++TU4gHWVJq6YfStRd?=
 =?us-ascii?Q?6n951cri3Qb+N6glmZIZFUbULdavHmCvjX44vuqjEArmkOVIWq6gzDizdPAE?=
 =?us-ascii?Q?hK4r4pf0wj6eICwouMdBBJXOevg8WpSj7I/XTHBda2sJqF0xq+tjluWAsPY5?=
 =?us-ascii?Q?qFybR42D8gk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aHgJVkLj0qZpaF80qaaDCb3O+wnam++euE6na+SeEQDvMYCt9euzSakXe5/P?=
 =?us-ascii?Q?fi7cZxjo1UhZgvDh9ttrFl2SZxQA536+el3XrYvGPxqTgn4m/RGj/K1VDH7z?=
 =?us-ascii?Q?9s8+BCP5bH6Pe9quTg/pPrlNlqNh87q3j/lHBcLpYivJxr1HZnPkxh82cHCu?=
 =?us-ascii?Q?DUzr2fgS1AIL/8TE3uaElBL4CwuhkhPrx7V2/qCXkVdS4nTwSF9j2hMZ4Yoa?=
 =?us-ascii?Q?pp6XpXiVU6SjangXbFVvcwJkCdV9SYS7LR+luDH1cVzBhzv3Ax9ibshnQNw6?=
 =?us-ascii?Q?hexv9irivflcLZd6S11EkKLv8MsXQbwHpAjm+CD1S8p5AS3Ev2rtKQMoMgtz?=
 =?us-ascii?Q?OZqDUFX5qaoT8xjTXtYKFHCC6+OPxu3MSE5H7fOGD0l/919LAnlQde8/sWv/?=
 =?us-ascii?Q?1QhjdQ0KR+cq8ech5numdbI5+UE9UDoZsGaOOLjFp2+drE3M1bpRvvMrpNkD?=
 =?us-ascii?Q?/gngOFXVckVQrCP0qls0xxaf2skI0B7qa2qMJJ+kFsrOvx5CMIBOCnslVLTr?=
 =?us-ascii?Q?r+DzQithjPUocSTwiCQmXkHkXH5tnb5ZU6E1r1J1AX/BpKUy8aNSQFS/Er1I?=
 =?us-ascii?Q?q53nXIqMzSJOJAVlFuPXetSnG5Pqy8IyvrSJUDS5M0xRa1Q/g982NgF6GlzB?=
 =?us-ascii?Q?9xyXupcNRxC70fx7WPfDnRbA9afSBknWhyY8Dr3h3OjS12bsrqcyCoJpu8Yh?=
 =?us-ascii?Q?Vkaf2F+PnSOMN1/cj5fWyI8YheqHg7cZpo+Qe++vY1+2+WYzkdWC23p30xOA?=
 =?us-ascii?Q?a7/E+7CcztyOmLl3laK2UJa8T/gLmWwSwa8ewJKm1acPYsPSGGC43iXvHuYO?=
 =?us-ascii?Q?dM1o1gIsZp8VIfsnC1oK+WK3ILq2QsIkWxRBDsi9rmlsSJYPXv21N2+0tEbH?=
 =?us-ascii?Q?OyBxxNwb/oWtoKSNiwlzQsfQhRV4WjvKD27hU/wYOpNOeIXtXQXbuk2gIga9?=
 =?us-ascii?Q?Vzlkj0ggNM8btHsuiKak5wKR7gNPFH0EsiDma8eKL9qEYmsT45WXh0E3BgXS?=
 =?us-ascii?Q?XNQDXddlCXlWlvgjEBQUt7jZQFxaxTg6MlDdz6qk+YYVAmgeL755fpQEs/Di?=
 =?us-ascii?Q?4dGVPhEK0wBDqo8TrTfZEKklO7QOZbpFBjjwl9NR+FGWhM7plx/d6WhUzHeK?=
 =?us-ascii?Q?Xgx1GyO8XhaoK2qaoLLxnDp0cSp651PBQDhP0+a4uUmVFPhmlgVED9LjnryN?=
 =?us-ascii?Q?FhVZD6LbBQNFLP/dQicHP7j2YEp6VBDmmbxfeC6NN9zJSjEpaObkAWI6LU1r?=
 =?us-ascii?Q?197+l+vQnUsgHfEd5GsOxEpVV1Uh43Mz0uBhSfeLN/ip8vgBuVcdBKU36YRS?=
 =?us-ascii?Q?tAIvnZTpToztVQezkFNkbmdKAl0Ylu62Y4eXMutFafAOMpmpmroNwd+bxjx/?=
 =?us-ascii?Q?rrr20GOiq1GGZeD+Iry1LLOpJdiFAlRTsn71J+wxOHCFXOaetiwPmShk0xwz?=
 =?us-ascii?Q?3REtxCMb0DA1eQZbnrmXDmYWbChQhhMVqyh3dSwgC602TWz5ZKKMwSXXET8j?=
 =?us-ascii?Q?BCUDlX631WLP3ZkiH6V+caU37XyhlUznO4UWiXUa6bW+/hPoC8w4u5OAD0Fl?=
 =?us-ascii?Q?ccI71BZ5BwYLGBJLvAtzExPGcsaJzSu7TILykt/RHy8gYtLN3WrK5kI5pf4d?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b975fcd1-7737-49ff-a4df-08dd9e2a9577
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 20:59:49.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXEo5MkVl5wpXZ1G2LMKETAaBJzWXt3HGSGF68LcFm7hwTwZOek0I7VoHGld3EBxLdfJuoqJOMxr8273BO10MMdyYdQdNnxV9ToFxjLLL5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4971
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 11:57:05AM -0700, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A user reported that unit test inject-smart.sh fails with locale
> set to LANG=cs.CZ-UTF-8.[1] That locale uses commas as separators
'set to cs_CZ-UTF-8 ...'

> whereas the unit test expects periods.
> 
> Set LC_ALL=C in the meson.build test environment to fix this and
> to make sure the bash scripts can rely on predictable output when
> parsing in general.
> 
> This failing test case now passes:
> LANG=cs.CZ.UTF-8 meson test -C build inject-smart.sh
s/LANG/LC_ALL 
	LC_ALL=cs_CZ.UTF-8 meson test -C build inject-smart.sh

need that 'ALL' to override all locale categories.

> 
> Tidy up by moving the test_env definition out of the for loop.
> 
> [1] https://github.com/pmem/ndctl/issues/254
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Fixed up above test while testing on pending.

Applied to pending branch:
https://github.com/pmem/ndctl/tree/pending


> ---
>  test/meson.build | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/test/meson.build b/test/meson.build
> index 2fd7df5211dd..774bb51e4eb2 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -235,6 +235,15 @@ if get_option('keyutils').enabled()
>    ]
>  endif
>  
> +test_env = [
> +    'LC_ALL=C',
> +    'NDCTL=@0@'.format(ndctl_tool.full_path()),
> +    'DAXCTL=@0@'.format(daxctl_tool.full_path()),
> +    'CXL=@0@'.format(cxl_tool.full_path()),
> +    'TEST_PATH=@0@'.format(meson.current_build_dir()),
> +    'DATA_PATH=@0@'.format(meson.current_source_dir()),
> +]
> +
>  foreach t : tests
>    test(t[0], t[1],
>      is_parallel : false,
> @@ -252,12 +261,6 @@ foreach t : tests
>      ],
>      suite: t[2],
>      timeout : 600,
> -    env : [
> -      'NDCTL=@0@'.format(ndctl_tool.full_path()),
> -      'DAXCTL=@0@'.format(daxctl_tool.full_path()),
> -      'CXL=@0@'.format(cxl_tool.full_path()),
> -      'TEST_PATH=@0@'.format(meson.current_build_dir()),
> -      'DATA_PATH=@0@'.format(meson.current_source_dir()),
> -    ],
> +    env : test_env,
>    )
>  endforeach
> -- 
> 2.37.3
> 
