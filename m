Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CFC189905
	for <nvdimm@lists.linux.dev>; Thu, 19 Jun 2025 01:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750295204; cv=fail; b=knsD1q18HF5je1hkLCe/NEPHz30RH+3UW5rSjlJ2X3dGYbPGZtlWdCJzm5fhxDt7lJRvRv5tHIVwu/y2opZp6kIXbXtumF7HZK0VwTbfljrowSPrkwjpT/r696CUDBYs6Qe7pM+wfm/Oj11Jz9InZUhoHVmRcbspi44wKkoSD/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750295204; c=relaxed/simple;
	bh=gsIC53iHSgoL2wybrZiYrOOitmU3e2/LizanN8AXPx8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jd0JDkXosGhlhlXS246oz1o8iSnWpzcuIHjta4r8qdPOC0784VwhUFzZnA/Bqa3sA1OTnnk6NvYzEpofwKXppOVgUEfyckUe9YczsL063yuzflhDLcmnkSw+gP/aZy0I4rOZfYL3hW0/jg8uAteDH4IOJRSyoxRwd+acOcTMu+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kbtHiBR9; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kbtHiBR9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750295203; x=1781831203;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gsIC53iHSgoL2wybrZiYrOOitmU3e2/LizanN8AXPx8=;
  b=kbtHiBR9RS+SUIzqWbssInbRLblM4w0XSzw4dvrbAT0xCOqdv5eIb03F
   FIina/Wbjav2uEXa6p6TtfJjeIHoDPX7tAk8al2t+6Bj8OtrzvgSq0giz
   Jv9qqC8Tk0+GoXG7juqtwOH7m3XNdjI07mbBtDegvij5GlvKImPE1+TgJ
   0a7eMsOcNCRSXwVt+btDPTeKShrVPYDXfvQL6XuUmRtas9LOoqcKV397X
   vdRqLiSvbdEVwSgyemEZFXZP6Ycm8sdxA6d1KaK9yDOKY7M4TUSxLeEzj
   OtrRBsP/Uob9SyGJyTOGUXDgH6CTReHoXrc6Zq3eUlJlNrfgUyL+aV55F
   Q==;
X-CSE-ConnectionGUID: nSboTSIzSzi7H/jmDIGAOg==
X-CSE-MsgGUID: jle51H4fS/i0KXGlQ8c4Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="56358185"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="56358185"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 18:06:43 -0700
X-CSE-ConnectionGUID: /PJvkQPIQI+xok13aB3jZg==
X-CSE-MsgGUID: FgMaZx8KSdy04vpLvFDBjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="155884584"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 18:06:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 18:06:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 18:06:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 18:06:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJIXUSuzg6sQPFQeOpqmy0VnNGUq11+dwcr8TsNdidzpoQ/Np+t64AT0Wh0OHe38o69465XsA+n3ol9xb7Hunw/FlFHIGmuOQ8TOMIl3dRf1gTGEJBUDfaqetvNwAd2hN2fZZwtf21nVWEG12Qz5ZyNKxdr+0N/N1+grzWE81k5bLaR9RdlM6mP5DIoov7HJCMFzTztNl/n8QRFRuD2fGOpWHQ1TLp3GhyvDY9kcWGN/xvP8bf/BCO4bEstfYMZGH/lZSixDxKTLlQuXJoaDj5UWAjmUxFSJBoJ9MnzQfvusRVnaLn7i05+tBcFsFJiVYqcoyuU6ez2+1TO8X5i4OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ve+wyILYGNMwRLNVF/K2lrORUYZ+3Pi44Mxq/vF279A=;
 b=qIsq9+UrLcV67DhLUUhjYAjVGc8srXkg1bvb0NX61cT9UvOoCAFgubsFy8ONztya9m44RpKmSrNhxGV4luIvubF21qKyKkXhMOFZK5QLZbARBwT5vee1RoHMaqvOAxq/0K1S6STPUyRKmAFMeJ0+iz1jiYC3SLz0VMYbcVHu6pJS18XzOcLf0r7bc6PC1gMHiavF6bp43XoVn4eWew1MLRzNG7/fVKCq349cGRRA/KGiXMAEiNPeVTmEp0RCvNov5LLoi0XlIGuZa9IbiPyTFJ8QHYT0k93XzS89LMYtagpQh8hrgCuFUFDcfchGA1cc3H4UHYwp329oOtIqnzle9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by PH7PR11MB7642.namprd11.prod.outlook.com (2603:10b6:510:27d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.24; Thu, 19 Jun
 2025 01:06:38 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 01:06:38 +0000
Date: Wed, 18 Jun 2025 18:06:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 3/5] test: Fix dax.sh expectations
Message-ID: <aFNimwh65aJIg-BF@aschofie-mobl2.lan>
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-4-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250618222130.672621-4-dan.j.williams@intel.com>
X-ClientProxiedBy: BYAPR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:a03:80::37) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|PH7PR11MB7642:EE_
X-MS-Office365-Filtering-Correlation-Id: 335301d5-4558-45a7-e486-08ddaecd8b4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5eN3E720WmhkmfM7/FjhtNVv/Y65SEprGfjiBoXTYdBB15HVwzH9ftprrGg7?=
 =?us-ascii?Q?DWUow5uwBuOxCvQ0DQUZhEkNx1ijoSIr69A050M71ZsrbxErEZMy9+pFY926?=
 =?us-ascii?Q?HTJVvblI1PG+eqwMrJQXxFIVMxic6E5zTKEWgTuuhm7M9BTDe4Mf9tV4BpAP?=
 =?us-ascii?Q?YyJikqy21nWYntPZWEaOVTgF7ulgzyvX6JUxice5W31Bu4ynM8LEOOpHFn3u?=
 =?us-ascii?Q?JSqu1vInJ8JJGRmupZQXCu6oxV+/RoCt6ndki8y3zar7bLHeSj8xu0aQZwUh?=
 =?us-ascii?Q?2g7VUw0FnLAmD0LGt/gA3Uw/t2M+noJCsTd9zjX+8s9YUrGL8gnRGhrgAfUx?=
 =?us-ascii?Q?qNMUJpbwjmuh8H+HGgTvIKdpWp6Lwewo/3txWPw6mHzls67KQRS+zdUm4HzM?=
 =?us-ascii?Q?jRTeJ2/TN+ePAql7IQ6n+R6Hp07MdjrfM+vF8P6DudHWckU37z59rsEyokcE?=
 =?us-ascii?Q?RBHNEfC61BoNV/xKKq5iJHhvrlbEadCoel5qg4BOb2r1u24Y4IqQZ8UbSYH6?=
 =?us-ascii?Q?en4T5Z1lcE2dNUFmpePAohW2HVXsvGE6tQ6M8+q1BzzPKB6p35YIbpVjnjON?=
 =?us-ascii?Q?+UIbs44UGCrXqW7naMYztTomP8Oc1AQCE1dyAPH6QUtrvuiQ2YWXw5hY4I7p?=
 =?us-ascii?Q?BbhngjUsFGG1LYrXmkoZ9wFjgkWeMvoHkcbdYNk8CjaGOJ5JdH1+4ZnTOI4d?=
 =?us-ascii?Q?MWs7cFQo/lHeCPCESf4RBZ58NZIKFvJDRqrhBlUNvwRar3U5NulytC1ixEV+?=
 =?us-ascii?Q?Udp4Lzy47C2A37hSIfuOhI+VqN8S8MaN4ITKkMwlL9CHS7ku15v4ezr8e47w?=
 =?us-ascii?Q?OPKx7nzZocIwYCHdKSywDNY5q6mA4QqKvqtq6IKtGkYeXhY5jUiEJiQLGlus?=
 =?us-ascii?Q?mTvxn+fi0Xr9w4olE19rSiRkBuvJ2UazgT9Fz9SC23TDxQMe27bCSmBYYdKX?=
 =?us-ascii?Q?3zzMH/QzU2xq4ctr80K5yBWgKm8U/TN4M5pUOdr5sGkgGS0KpPE4QlA8lsLt?=
 =?us-ascii?Q?ifsdGKI0YYLHclwuprIZFwc8kIioA5pkR4lXoK3GtOdkLh9MRu6GdTFTyC2W?=
 =?us-ascii?Q?9gn+c0i8CuaqLtFnftEL0Oh8vD/+7n5oHgj1pkGAy4BZtVwruKWk0u71844b?=
 =?us-ascii?Q?xJBY0dzNAqqTqjDb7fwki/+IqPr9vStGv0oxc8IyobVbmRVZvPHVMBtBOPDF?=
 =?us-ascii?Q?2a5xf2VbIOcgAEwLb5KVFqBHsau377PMx84Vgp/W8Skp8Br9bpyWF3rRllE3?=
 =?us-ascii?Q?mi4JO6MKx1xpgstT1q74EfdJ/CRbdVsTOF4jELXcX2crv2Wa1dtDV39whT2C?=
 =?us-ascii?Q?iffzbauepp+sDntHFc0usV8KUH2mk3weANV+AZ1kA3NWLEwCfucu4XxFOPhm?=
 =?us-ascii?Q?IiKHz4jQ8FcLhyx3AymSHnNdh8qONYIjFbcuN8X6wPhKIZRgnnxlI3IY7+vf?=
 =?us-ascii?Q?vbttBfWMDyc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lWyzs7jCsCa1wV/kpcNpZL+ZMCSewVP1GIaqWnwDNeF//nIiQCH2ykIfKGZz?=
 =?us-ascii?Q?kB4S4Uj7Pe/rOzCHyXmib0eGPhTertghp6PuHaxsgDRp0FxT9pTv1cua1I+4?=
 =?us-ascii?Q?/o/zawEN8OnYI/bdzv4gqUnvFGXLR29XYKG90rP04UsMQSTlWG7tvsKJXHN1?=
 =?us-ascii?Q?FCAC67xt55AM4PN0QDLUdsxLVgh57vUTDL2+Yl24drhL+mO6Jp8t/Mq4UC0k?=
 =?us-ascii?Q?R3NOPrJmBKPjWuyCphBkayhSUfeMAovT2w2YSxWCk9u9eq+75SXl6xdl6uJS?=
 =?us-ascii?Q?cjsuAOZv5U9jMGXWmPX7134lWtvEq5I/cFRc+0gupspsKrs2wavPwZlJzfV/?=
 =?us-ascii?Q?mnq0co8UAjrWY0DiIPjSo6Fl/w26lOYqJ31eraNiUPbIgxO8zInbp2aJXBDs?=
 =?us-ascii?Q?8uBmOepZ49azQNVA6ojZbeVpuO7bgGaARk8tXZSkVvnFg4t7jCj2slUf8n3R?=
 =?us-ascii?Q?cpqDoMpgl+NyzUV5I0Pe2eyM2bsfG8ehs3T6z7jI+LWsOn04kPPIldTcyjXK?=
 =?us-ascii?Q?B+bo/RInH619VMb3wf30PubDQV4kUj5AaWxw2OWkHP0V432Uq92v2YkKIyr3?=
 =?us-ascii?Q?pgmKvaLvum3/tylrL3p46gM965DJKdl27IM+5ugZDOrcGiy6g/8fd/MT7e8g?=
 =?us-ascii?Q?uYvGiFF475aM/iHVQmk5XZ0GN3L90bNFY3+8DePUrUYvXfjTu1lFbbGT5ouR?=
 =?us-ascii?Q?mrttjlB4cvvfxI8geBGa+N9pfY9LFc8B964xPnG7xY/A6YYtuyiAFrp6vGMP?=
 =?us-ascii?Q?4pvyMwKZ6j7KyuGtunX4Qz+F3/SDVzyXuno8a1GRGzuPfExAQ0C1mf75iVK/?=
 =?us-ascii?Q?605vAapwVrUFCMoGOI+YGkrv5hU9xngaxdNC4f3hnO14D/XaaKOBmkdQWltP?=
 =?us-ascii?Q?QfzMecR55o+jNQM2xruukciMlK33+Bp9LVBY2eYZl4FJMyoasgQHV0bUa3E3?=
 =?us-ascii?Q?g2PdSpOsDj9WKlnX6G+0gvGTyu9ZQ5oFjusDI3iC/c+2FadPJ9gS2ERHwI4p?=
 =?us-ascii?Q?VgvL4m/3PPczZiPR0+bdJ/jwa5MbNENshv47CmBVxzSeFECyAljyM+AQKLsi?=
 =?us-ascii?Q?1zE1J3oY7wHHnDzTdfWlnFOhVDwzgdT1pxrho6bBRA/pc5c+z1jBllpIdYc7?=
 =?us-ascii?Q?lQwZafi4228PzqKiRLwiUJO1M0Kk1aOonh49g0zWAfYREgDM6P6NJayraTRQ?=
 =?us-ascii?Q?4fyND39sMUTHLOiJZO9bE/f2PQiyoeL2IDEdJdhvhET6Dm2ckeGpPZCetJ0P?=
 =?us-ascii?Q?zkLpC6LxBT27TS69TdLyGsz8jfzcR/9Dbt1MNLDtccR5wmRsU4/z/FEE4ETd?=
 =?us-ascii?Q?g7NP3a5LNS424bWRVBzliAMvALku2RP/Ar3qli1OVtKbqslmIv5iGTuzlRN4?=
 =?us-ascii?Q?/G4v3yztX8p4tu9UsyPc6r59+tzWbGxRSp59LDIXEW1ONwYPYHjDMhTW6ASK?=
 =?us-ascii?Q?AOMUVx0KQRVVR6YLTU3vm8fEkMd++J6Gi1tz8iawiXLBAHWOYj14klJpf9LH?=
 =?us-ascii?Q?JBD/iS6qdHmZcYon7fxly75+p17eSgTNnFTWYQGFV4f6rrIb1bMqZuaUGY03?=
 =?us-ascii?Q?+ZOWcpKsLo9RyLv37QE7SxPnrviv/OIWlpSJu5mExdIt9A11+PmLonITJnjS?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 335301d5-4558-45a7-e486-08ddaecd8b4b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 01:06:38.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJWVJl+8PsuFth0IWxfLDofJemgC94OLoodc7l/+qVt8ZasOzOpfp7ICy7afy206hfRPzPqQfuTvuGPtdQ9gzvy919tqVxeOuq0k3iMZ0PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7642
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 03:21:28PM -0700, Dan Williams wrote:
> With current kernel+tracecmd combinations stdout is no longer purely trace
> records and column "21" is no longer the vmfault_t result.
> 
> Drop, if present, the diagnostic print of how many CPUs are in the trace
> and use the more universally compatible assumption that the fault result is
> the last column rather than a specific column.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/dax.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/test/dax.sh b/test/dax.sh
> index 3ffbc8079eba..98faaf0eb9b2 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -37,13 +37,14 @@ run_test() {
>  	rc=1
>  	while read -r p; do
>  		[[ $p ]] || continue
> +		[[ $p == cpus=* ]] && continue
remove above line
>  		if [ "$count" -lt 10 ]; then
>  			if [ "$p" != "0x100" ] && [ "$p" != "NOPAGE" ]; then
>  				cleanup "$1"
>  			fi
>  		fi
>  		count=$((count + 1))
> -	done < <(trace-cmd report | awk '{ print $21 }')
> +	done < <(trace-cmd report | awk '{ print $NF }')
replace above line w
	done < <(trace-cmd report | grep dax_pmd_fault_done | awk '{ print $NF }')


Thanks for all of these Dan!

For this one, I ran into more metadata in the trace file, other than
'cpu=' causing the test to fail. I've tested what I'm showing above,
which makes it immune to other things in the trace file.

Tell me you are OK w this and I'll apply this set to pending.

FYI the more metadata was:
version = 7
CPU 0 is empty
cpus=8

>  
>  	if [ $count -lt 10 ]; then
>  		cleanup "$1"
> -- 
> 2.49.0
> 
