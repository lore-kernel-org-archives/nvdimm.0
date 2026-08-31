Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD39E370D6E
	for <nvdimm@lists.linux.dev>; Mon, 31 Aug 2026 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788205956; cv=fail; b=KUbEKp14ttbI/tEHFzzvOhRvNp564VOUcQsr6q6hTAvIHoKWhvM3vDtzvszZmvVDVEVo8Q4f66kCp8za+2csbuDbOXS9voNAQubIj4UKLSlrpfzWlxrIA2FN92HmgL/WPwGeKpauBoG84biUucRr2z+m13Ql8kKEzJtuwDejmpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788205956; c=relaxed/simple;
	bh=cinlMIsjWek7ajY3TOY+GuvL+7pecbTXsE0fED78bhc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rZ19jyjnRW/G1/eb4s7UzjViLZ/YNy0sz/cHCR+mYj/MKwa7Li+O9YiX5pAJSwNiFzW37kdZSzmQX3ED5riPMYk2c1BEoQCwk6d5EqXYvJNdLKHjVJOmM9BIpBZhXIdNm0IsIfRrNm3rTLZCI2RPniD02CRAdjZwL1+8vhngvL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ObZ2aoDl; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ObZ2aoDl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788205955; x=1819741955;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cinlMIsjWek7ajY3TOY+GuvL+7pecbTXsE0fED78bhc=;
  b=ObZ2aoDlSdEhFfbENjIZB37zGvspYZekM8IPx198BgqcpoQT04aQS8sB
   BN3AN9KyZ2jKe9mX6t5BP0Bt4TzK2kqOp78YBPmmDTHJxxGQtIsXZyvdH
   gmjRJVmqQtLJXvcXKE09GFU4EEFqrCyo51pMy2cQxskQ66HFqQjeSM/gI
   KO1Uyo72qTNEmWhxkioGDvg/NVxT4T+3MJmxVGnt7SHWfPnYwQCrZjFqh
   ohYrEoZjZwwUF6IGQdOk3JpR7SVOL7uLu/nTrRQltcTzfiEgLiM4iRG+W
   G7YHeRgbHcANvgRRGKtYDDZrzXwLCzFx5UyfzOA/580QZMYEv+d1XbbQd
   A==;
X-CSE-ConnectionGUID: dahI/l9WTcad2eRLCntQXw==
X-CSE-MsgGUID: FwODbE3EQPiHSM3h/MDbog==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92434800"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92434800"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 12:52:31 -0700
X-CSE-ConnectionGUID: gIoyWQWCQ8GMjICCC9EMmg==
X-CSE-MsgGUID: wo2v5m/2QXWdC6BCa/i+ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="293719461"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 12:52:29 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 31 Aug 2026 12:52:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 31 Aug 2026 12:52:28 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 31 Aug 2026 12:52:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZuA5W/EB98bvqzbKoz8u53mUeOVRCJXtNNdhcB3mPPd+o9TfUT33Pxawcpy81S5gWtIBnV4hxcyzNX25mMYh7Q5/TE7KTxtGKqte8GzKgt1Lkvy/aA6aCPBFdA1IXLlRaqvgl2CpBxRVG2lCOVLppDQyAXA36oP/Ao1B7vF0Fn1nxQPT4o6R69mBN0vS8ERhBMWvu88T6sfm7KcVc098qW8sTftS9g3+aYedCjF0ksyplPQXcv1kN29Pzdqaixnzl4YcqQlnKPivRrU2RHvirYJWDQC9Lj4atmW7fO2fZeLA0J1RjCjJD6qx3dGjJKsSCFTtNX+B5bdY9/bYZ/+8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0z7lKlzZEO0Ow+T/oCnB+dwjECmDZNmi6i8lzErdt0=;
 b=FIRs0X8A0nknkPiSMW+EX9eHNT7Ps8/jzGdsDGk/IcWssNzfQo2zSei8BJ9QeUhMrN1dJXWIpsAQtiPoGeiw+wFnEJqeOQu8MnQQINcg2l697or18BiwpmsgkxpnVHbX0aHOQxaDWhDkLidL5hprkCkdS0rAw1tp267oMyY1Wh7Xb8CRnu28nTF9SK5962HbE82NsFflZOG17ullYsil0HVGgawTzkhRsgo/JsthwUyg+ew5/H1/iI0DSZEZR8LoU+64IJ4hDxBc64ptp0P1/3JkYc6NuuAJ+2IHbrTBigUNUUercFr8PzCg5s0Q+Gv+dfZ8hFteuFdtFZ9mY7Gd7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB6346.namprd11.prod.outlook.com (2603:10b6:208:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 19:52:25 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::e721:90d7:9214:2d53%6]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:52:25 +0000
Date: Mon, 31 Aug 2026 12:52:21 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
CC: Richard Cheng <icheng@nvidia.com>
Subject: Re: [ndctl PATCH] test/cxl-poison.sh: test scanning past fully
 mapped partitions
Message-ID: <apXbddZrE6fmLnfk@aschofie-mobl2.lan>
References: <20260701044205.1589967-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260701044205.1589967-1-alison.schofield@intel.com>
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b9f3068-4423-4837-5428-08df079960f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|10067099003|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: AxL9GKtiUC1FHHkY9Sj7lZEYoRCb2+o3mNINSTCYah1oSjJWqJgDoi8bS0KdXpAJP8+kyJqw9MbkU4Fwz4eHYbCyEFZ2kKRnZXm4F07fw6p1qTCneylh2FJ2HHeWLMNisXSapRTiWmkIXEThDPd1NZjwQYMtX60aDkTftDY0mWJUHkBXM1Ofv6E+EzgIR+fMXnjVGLygcDD4So6RYW8kB+1ZBZNuZIb5GSyxTS/DuqwV9+MddCDcHlKSb8vKy+z2l+A0eSYYQC4fB55Rp5IxJWhZEV80Z+70QRAJ+LDqIgiAp5Wm+kkW7hoKo57ZcTbrfJjs2BYY2raFHZ2FoZtnePoUpV8Y0Wue6toTWi+NKEs+D9SjIGdpJNoDyEhfO5iXTYx9168XLnII/h0+Sx8UH+1XKOHoLEgtLaH9OmrpANf+9M2hxoW3bQ2340i2NdLzujmOamUCJlzUSbzhFIUQ+Uh9jOpb1jxNgN4eSpYCYXEQIOUG0LLDvjojtzVgt1W12kPTSN/0hupwrVamtVgnUCi3QV6i4vv9s796wfOHNahexN9dT5i6//clpEDjSDy448ToPl8/n7HEASfAAQYA+DLpHfYKPL2q3zYZaAgu2VPRL0jozBRtHoY0OtVfE4Y3b3EqTilnPD4fYORn8HAMhJBIt0F0oOLJRfk93Wy3QYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(10067099003)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8SF0lUMhgE2EJMC9ojRmPM4KOLXYZoa5E2q0LYDDAoGVmsXgu//GXZzm5tbu?=
 =?us-ascii?Q?uaspt5yfOeMHgixbPUOSdGyO6cQs4gCtJJGkxrnLdnb5nyE9YimfU8wDb5Io?=
 =?us-ascii?Q?cnP2d9R3E3B6gRYasKSlYml9MRmUzPd34VE7NBRcsdYWLj2Cl5TSFD1e1CFX?=
 =?us-ascii?Q?GMfYXuf+3W19vXvpVz11WoOZEpBiq/72U+vWrt2GNQObBXLTOwIp+8WyNbEy?=
 =?us-ascii?Q?hZ3oZ0eYY4edoW8cLxhXe2xYh6VRyYYpvG+bGAr7Z/uuRsQ8ZCb7Jcmi9NNG?=
 =?us-ascii?Q?jf30D6aaGpM+CJtkKEyCsaan6PInDwyJq8xx+6A8niZl2B748FnsXN0YXgPy?=
 =?us-ascii?Q?LcO5GfetouF7ZUd5ZEUW/oQ9vq1+6+vbGb+E0wuGEGe3iSamVPxwj3X1p9Pg?=
 =?us-ascii?Q?GursHB5m+Yui8myfsk5PsB3BjC5lsgEAkQYh+2C4Cy6o1YVvt3CFVopM2uos?=
 =?us-ascii?Q?UuBPGl+uqTac0ZtyXdR9nW3Xv3TQksvQaGbzGx6JRx5SeRKdLiy+uAuXv70x?=
 =?us-ascii?Q?fFKb355h6aWbJhtW5BSXakPED6GTkd6rN+9TW4z3KbfHR9+/6JVESz+a7LYK?=
 =?us-ascii?Q?vXmULrqfYAe6wS5gu1ewBU0xlo7EUL1GxZwE6dDkDQ+gj47cE98AwnHe03wI?=
 =?us-ascii?Q?mh/YLt1CQaNIhe/2L94yLKe8G8VQgXnzPka+GAmpNF+G02r7ZPf4Uo40lFAP?=
 =?us-ascii?Q?lMAuf7rTYgHkpOtrFZQH6kQrHBundvxrqjAl1HODDhEwSHjv3TwV1FKR4uQ2?=
 =?us-ascii?Q?dokXRQoX9RAMK07kGURcIv9oMFhegTlqVkpbsScrc98s0dJs5T85klRdNcHY?=
 =?us-ascii?Q?iyK81Yta2WaWrqioA9IuXUA8i9yt0GBRvBgXrgv8MKklCBAXGSrfr5QkWZO/?=
 =?us-ascii?Q?G2FewJvOetjSJZALrc9um71RRWNbFveiblhvCwmvQpiTVZjjIlbxQOaRYPTr?=
 =?us-ascii?Q?iDdf6ol+zf61V9zaPEJ7LMKFkWt3VQCPQA3fcBxY3oNGdhS9xT6VXFw5dquK?=
 =?us-ascii?Q?X1s3ZRiddop/VgrMRDpkXl7JFY5pmwzgVzWB0Djy+e052P2/nQKa9CGKv/YX?=
 =?us-ascii?Q?xz0LRifeEyJgqS335Ob1avxTcdsdOKnPr+aJpfjA2QgqQdLIQEG2ZT4kYAfp?=
 =?us-ascii?Q?UfWSNLYiNIVvyhXsbvUp3+H95lWHl9tIHztJOY/+fYWhsQbWIso1N7hYrn6m?=
 =?us-ascii?Q?fsyGComGoNI4MN4Bb5ZscXY1MujlOVANykd0tsI6diUsX/InbVhiu+sGdWwl?=
 =?us-ascii?Q?zm2pmsPOj5Q2ZvLQjeTdQ3ni7Om7hjzwNyxkxejitBl7djPfCCWPr4LB5pz2?=
 =?us-ascii?Q?XgpuXT5y+CXnOXOTX6GoifMGxvu0G8+7GPdBtuY2rCZrckGEdkuKbAFo2CsO?=
 =?us-ascii?Q?R7+eUwN/jd3mWp8F30cxdUYwgaEP9Krmet9QEIKEqbbgk16onGOykvp4cDrD?=
 =?us-ascii?Q?xowq7f6XghbN0KiK60jGo5CAzDjDdEBAdq5UrrybfRBbHAbYgJ9NjjgmzUZ7?=
 =?us-ascii?Q?lhGhLEiyt0RteLBt4qTOl89PoLzme2CoSQ7b+5afWC0knKHm0uewdasfEkX0?=
 =?us-ascii?Q?8Xqn232v31Pd8psJF9VJ2NDSsip9T20QZKjaqbGObEbkU38jHQo04DzAHrbe?=
 =?us-ascii?Q?Zygkuv+s2R0BlHL2WNuJOASYY+DaYVRckkg5AYo2hTW7dGSTCLVaFgiZqkbr?=
 =?us-ascii?Q?OZGiAUX8UaqX9wC0vGet3KYs1CUgv2WyQ1zIv3+94OQeqsgNGtmextjW44M5?=
 =?us-ascii?Q?ZBSVLHmwdE9LCBBiT/cWOVmRajnzYkQ=3D?=
X-Exchange-RoutingPolicyChecked: XR2fDIprntSvfeT8ULG+m6dmSy4zMjSawynlgNDGFSnEU6u/jh/ZoQwJAiNTJTyO7Iz+6MgHYcuhkOP+oLuhi1wcapZtQMSBqFVnQ+nxD1HFK4f+uyCeSjaOIP5crp72aljv6bpSgAQGc10JTvgKxpOPgdQbczGHqb8QWohUSC/o2FbOf69IrrK6jne9DGY1LGm7CSxWo7TyAQ4RSwPPp3WHZoBUDy6MmQ/mahFscwtVMcHxp8CA+6/Eo9l/ZM3wJJQgbPnXLh8rreEMkJ44zZkxxIpYfzz4LVmWzj50l1xAw7kyiX2tY/esvaNpvFzIURDAJo97JwRYNcg1fcfceg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9f3068-4423-4837-5428-08df079960f2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:52:25.0191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgQR9VLiujWyY36wtUQPl4ly/oPJ0u7y7w51+xaHSbcimSoYl+J2rXa7ufLWjpa6bZtl78FetOwCuQJKidJNiQL/441rPXcp7jFm9hqwmzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6346
X-OriginatorOrg: intel.com

On Tue, Jun 30, 2026 at 09:42:02PM -0700, Alison Schofield wrote:
> Listing poison by memdev scans the unmapped tail of every partition.
> When an earlier partition is fully mapped, its tail is zero length, but
> the scan must continue to later partitions. A regression caused the
> scan to stop at the first fully-mapped partition, leaving later
> partitions unscanned.
> 
> Backstop that behavior with a test case that fully maps a memdev's RAM
> partition so its unmapped tail is zero length, then injects poison into
> the unmapped PMEM partition that follows. The PMEM poison is only
> reported if the scan continues past the fully-mapped RAM partition.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/cxl-poison.sh | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 49aa1b68c5c1..a03e08084eb4 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -219,6 +219,45 @@ test_poison_by_region_offset_negative()
>  	clear_poison "$region" "$large_offset" true
>  }
>  
> +# Backstop a driver fix where a fully mapped partition prematurely
> +# terminated the unmapped poison scan.
> +test_poison_unmapped_later_partition()
> +{
> +	local decoder ram_size pmem_dpa
> +
> +	check_min_kver "7.3" || return 0

DaveJ found this failing in 7.3-rc1.

It turns out the kernel fixup for this testcase is not yet
merged. I have just pushed a new ndctl pending branch with
this changed to 7.4.

The kernel fixup is in this patchset from RichardC:
https://lore.kernel.org/linux-cxl/20260826014508.9989-1-icheng@nvidia.com/

There is no issue with the patch, it's just bad luck that it is stuck
in a Sashiko set of cleanups.

-- Alison


> +
> +	# Free the auto region to use the ram capacity
> +	$CXL destroy-region -f -b "$CXL_TEST_BUS" all
> +
> +	find_memdev
> +
> +	# Fully map the ram partition so it has a zero-length unmapped tail
> +	decoder=$($CXL list -b "$CXL_TEST_BUS" -D -d root -m "$memdev" |
> +		  jq -r ".[] |
> +		  select(.volatile_capable == true) |
> +		  select(.nr_targets == 1) |
> +		  .decoder")
> +	[[ -n "$decoder" && "$decoder" != "null" ]] ||
> +		do_skip "no x1 volatile decoder found"
> +
> +	ram_size=$($CXL list -m "$memdev" | jq -r ".[0].ram_size")
> +	[[ -n "$ram_size" && "$ram_size" != "null" ]] || err "$LINENO"
> +
> +	region=$($CXL create-region -t ram -d "$decoder" -m "$memdev" \
> +		 -s "$ram_size" | jq -r ".region")
> +	[[ -n "$region" && "$region" != "null" ]] || err "$LINENO"
> +
> +	# Poison the unmapped pmem tail
> +	pmem_dpa=$ram_size
> +	inject_poison "$memdev" "$pmem_dpa"
> +	validate_poison_found "-m $memdev" 1
> +	clear_poison "$memdev" "$pmem_dpa"
> +	validate_poison_found "-m $memdev" 0
> +
> +	$CXL destroy-region -f -b "$CXL_TEST_BUS" "$region"
> +}
> +
>  is_unaligned() {
>  	local region=$1
>  	local hbiw=$2
> @@ -332,6 +371,7 @@ run_poison_test()
>  		do_skip "test cases requires inject by region kernel support"
>  	test_poison_by_region_offset
>  	test_poison_by_region_offset_negative
> +	test_poison_unmapped_later_partition
>  }
>  
>  modprobe -r cxl_test
> 
> base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
> -- 
> 2.37.3
> 
