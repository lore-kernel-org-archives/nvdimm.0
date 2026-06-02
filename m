Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776722BE65B
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 00:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780360442; cv=fail; b=HlAYuZ6rLBkA9fGiCxJ/ljj9/gGDmHERDqh5/AaRoU0w0CGJ27ePIc1ywvbk/QdgA5gZ6BczdBAm7Di4u8PGlYmFRMhfdNbhNOTCpKtzGSvuGuuwhOaW7tTNu89QX5iNjZPUetF1eyIli6bK4HSA5sjBFLsEqDO/nOI0fmNeeuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780360442; c=relaxed/simple;
	bh=luFJXSlRBwOre4c+peiZhccXmrCrFM5n2Y8oWm4yd9o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BFbkew4r0SGv//uXv5HMHYdzB4ZNny/dGX6GSI+vahZ492DE7dLQbq07RCUgAPSrECNRJuhKxqhGMxtDEvNxJ04gSW8XFvwUSdzcinX8YiOo2vvv1SVp/nXmwBRGvZItGzw/1TjqCPhNLDLwg1JosJ8QLtGbGFN/kGdKGCytVek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hfCUWS6y; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hfCUWS6y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780360439; x=1811896439;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=luFJXSlRBwOre4c+peiZhccXmrCrFM5n2Y8oWm4yd9o=;
  b=hfCUWS6yOH0J9GKfu2uEZln3f1HEBQSBjhPQrZnENl5cQPeBGz3ecv+k
   XHRI7a9n+oDEQZOnjac2lVQA/7KJA+4jPCV8jF++wgbMh8gwf4WHrcvTp
   N+VnzG0seqMETCMzAPvey/oo0G82tilOTA2zOHXCBrgrNbujetBPAToNB
   xQvjBgFAIJD1bC2W4EQzT/nID6KmJVQMuq0bwqRXcnOYz3+GKqnJETSqX
   sjOCJYaIQr9DSU2xEzCUK7V75ar/n83rC1uqvy3PFZdESciqv3OCe0Rya
   gJ83DNfx/Iqc+eqspz6B9WWYzUyJvUx+pjgAeNl0Gr8e6U+N8eU/6Yzz0
   A==;
X-CSE-ConnectionGUID: /NiGQFX2SYqcLCosBTmgPg==
X-CSE-MsgGUID: lcfJLFU3Rp2tBWLy54Tzeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="84756344"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="84756344"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:33:59 -0700
X-CSE-ConnectionGUID: 8j+dyQq5T6iBL0Nzmp/v1A==
X-CSE-MsgGUID: ncFGZo7nShKD+2YEHXFhHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="267601991"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:33:58 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 17:33:58 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 17:33:58 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.26) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 17:33:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zAVGOQAqLIO2hWh0B64A2bxVHWULewPixFEq8A/q2FiJVPRcen0226TB66ObX5vdZUim9aFjxXno9wlv2jnyxN3IpA1uIsqhonWZiF3Bga05gv3BrsOOSKlepHJr+MyYd0Uw3aGx/2dueNX6uJboWx3mWKKttsvbZ5szR0Xn6evvdJqdPRrHluoOwObZ5ya+q4EV49b99kqDbCJn7GUz0cBHJknxelxBCihYXwr1OBjMEbskis4OHmfjV4pvW/wYZWquWw/JmuFa1GpDPXwEfl15gBV9yCAB+zoMz0xI239MzylSrijXfMwhKIHnOfbj64d1885N+uCTQpt1Y2doIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Xywywxz3t86I8piWFY8Q/csdeih5Sm+S2GnKOZoTsA=;
 b=UTdFSevr+NMpbGszYliuBSP1XjZhqDjfjPV62mGe3/6gz+ZuWlDbgIBoaha/svB9C/NKB4aoTLMSA/sfKlcRt0kADTUKCrzqm6WQCMt+ilKoGQrY4JglqUUbY2Pyzgsx0tFaGMUHHgwepjBgw6cKDMqDA79OE0NMUgKYjQCJDXpjRneVY+O428GSUp5DFN2YErtgVCTAJvdcKvmZGR5hdIln0RHAHkE1HK6OkbPU8TFFi3B3CKifyFZZOdVvWqLKepD5iIhPkbg/jhMJFqooP+gQlrSUr7wcZ8Rrww4HtZAofFPXDAjEQssbAW6HcoLhcn4P9cJ1bfzClG6XPDDtvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA0PR11MB7212.namprd11.prod.outlook.com (2603:10b6:208:43e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 00:33:50 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Tue, 2 Jun 2026
 00:33:49 +0000
Date: Mon, 1 Jun 2026 17:33:46 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
CC: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 0/2] nvdimm/btt: fix a few memory leaks
Message-ID: <ah4k6qRKGiouAB7P@aschofie-mobl2.lan>
References: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
X-ClientProxiedBy: SJ0PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::35) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA0PR11MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d025d00-d747-4800-e2b0-08dec03e9d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|6133799003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: pE19Ot6pyBqGNbleLdn7qfE2iGjZr8IKsjRj2hJuiJEMy9d+n7xSpD8VIOvlyap7Rv0rGe0eIRDwkDJ5QvZ88aF0jDHgqNt9OQmjtshEPfCAYt5/4z7kTdBUwSpTWIyBMYzTbfRgsqwdRciP2zF34uOScX2D2p9eC7zjhWYNswoitzMn2d3gOzCLILLzSc8m3Adm0FStEyiFcWBv3vCegpKF6OFIGaQ73JsBHI/vJNj/2YkDffmfkaIxrVinGSjnaWWNQBNGG84srFz3yezxDK1ApypHM+nOC1xA9/ETeoSIEL789O6fiw7nq+hUs73jHSijcKOAufTpDcKjZHf+fCOWMF4XdQkPfSmkqswmFLk0IG/pcJcRwai0G+5Lb6U+zeP5ySptRAUHUeEpuHJ83S5/SvLxisT8l5Hcfj1tTE1db/t9KLj2k8l1i7StrmhKGf8qveV1VeSQMcs0AGuhCWA/3lFF1mYSwxLc5S7m9RUsPSRzn0vf+lBAe1DQom0jcXLu+V8OjQlD/U2HlWGhxmjUHsvB5kAWbI7D07uQeN5Nl4fnMPGdM8wAGVkjQgUXL7RqIwsoNr2mZN/CicZyzWn7vQ2fGMPGUt3ntGxj9/JZlLfJQKrl1x8MpbwptgdrlpmJ3KNU9Ee6/OsLUP4aSbdoBeSEuJAYkIICNWe37TmSqgsjItQhJol5Pop6vobq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJsVErZ9CNadQKUxqfXQZTJOV4SzdefoNdhC0OOMZ7AFSJ9Gi3Vp7fj8XOma?=
 =?us-ascii?Q?Rbsg5HSVq2R38eezkivZtmJGJdGnXE1Ok4Vbcajx7etp6keJwO7nwhy75dkx?=
 =?us-ascii?Q?Of8k063F0AClTGKpJsw03GaCTjsXrE5uKaa3kb6vYXmDOIwOU3I72P86W39b?=
 =?us-ascii?Q?TadvvwkwvGZsmfDmxSyaLDWbeXJ8trBq5xVznSM2doNVXf9PAURKdJigb9RN?=
 =?us-ascii?Q?aafGgaGI/4e8Fm+OZrDgqvy+K2S47B/xwqanNxk6Sl1eTNzjohE3Oyw46sM0?=
 =?us-ascii?Q?BXRKOgfdC0bNAbjeS+Y0jwwXO5MjzbbzyXrG9LRnBh+heYMer/y52jfzNlV5?=
 =?us-ascii?Q?CoznYzvdnhEJo/6NttxSRbCRm2AZeIZwyR73nyEp8ZS5u+QcRHlPuryvlko+?=
 =?us-ascii?Q?yV/lfNJKHR8W3eKpnSvK+BEEa6IXeeDMdRP8Nhh5sn7nodKgy0LjChLnTGaM?=
 =?us-ascii?Q?TeeHEXN9TwhFAzP2K+xo+47u2ztm99v9Qryli4xynsVWUdqhrdICUtV/zXd4?=
 =?us-ascii?Q?uY74jKoLt+sz43O9A4sgamIquFg/upQVdj+iohoG7kmN7HjpElCUTTwdr3So?=
 =?us-ascii?Q?6UXl1EPFYa5QE/tOqRE4FoaC53LFYjcyEFNK1JcA5gdvzENSeyLaCY0706V1?=
 =?us-ascii?Q?anV8ixZ6OFKJoy05GVlpxQwplIsrDuZmhBLTL4PSWqSLiiAvQnatUq9WJPOH?=
 =?us-ascii?Q?VY4hA9KdwUDZElzrM64Ztrm7tpUW05rzHbeLpaRvAH8AlVXmlslIqbIKGRhT?=
 =?us-ascii?Q?WbP3D8STiAHBzRLKJlOcT74P1EYGasmT34gkt00F4gpXyoZjy0DUScfw7IiV?=
 =?us-ascii?Q?DX1XWnibBTaSVTT9qAjqqzrfePI65RRuu7UB/E/mk8Use1WCn8Zs5Bk/1KC6?=
 =?us-ascii?Q?08bdVmnjYuwxEvpymefcZ1AE7QJ/TygK3iFmD8xJZbb5u6BdWbjqoHC+EMQ2?=
 =?us-ascii?Q?JNZfxQ/5XXWP+ujd7vcvv5/i3gYtzFAl/K2IYh55OGNshHt/2uCOHIZdCRlx?=
 =?us-ascii?Q?CnEFC6NYm3rLgWbgofeNujxUm7P6wOE/QDcgfIwyaHogckzRFtg8DWFBUTV6?=
 =?us-ascii?Q?vpNAD77D61ghQ0aTkLW6YqJH3w2Toh2yBDd1V9iVdzfB8VnH9N9twzn24GYQ?=
 =?us-ascii?Q?uzBTmCR6dD+i1ZdyHR/6fA3/8Ge3cR2y+l6jAEgYuvWucj8Lgz7IV/T7c1t1?=
 =?us-ascii?Q?ZIxEgov9U5rpfCDYXJ09PFE3Pp7etkKZaQgrAVTWWwq9uqPyYwKkKRxv8sOT?=
 =?us-ascii?Q?omda0HRvqYCMVqAU4BSFfYNfUghPfK7fKn46nvHeiI0CZgruwszpYXHQ41HG?=
 =?us-ascii?Q?TeW0mo7w59lnWqGCjQtRp4YoWiHrDO+wWvnpAG8QXvA8cugn2hdABPHb8bQM?=
 =?us-ascii?Q?dlqiZyRJs0X3elWWX843G9TPVXgzQ/mBnshiJ5pUnRoPZt1Lu12ANCMXgOSO?=
 =?us-ascii?Q?3zBc43uzTyBVgpRXqJr/8dUMz8GaopcspBq9DHKf9FTfdqNEPtuXIPyDsq8p?=
 =?us-ascii?Q?Nw13qAo4XDbJlWJiKW7rq8GGFb0/70pWQwasmN3rOXXkM3+rPnAamQinuGrR?=
 =?us-ascii?Q?OVRYr8RgXIT/ka2R8Db/HF4H0OZQKZh750GRW69h0jFk/iDuL52QvudpdPm1?=
 =?us-ascii?Q?CkYR13fSjsdJHrawQ7WWAp8O3h66Tk0uJ0OSiZ7o5IiVD9dNjkoc9FMo5Cip?=
 =?us-ascii?Q?20L5yDJPdmkrEql6ft1l4upBU5PWbMHbmfXKMDGZlvCp6SQVQCWEikRHY4ga?=
 =?us-ascii?Q?bD7q3CMVEF0TkQk/aPd05C5dPnCzs6I=3D?=
X-Exchange-RoutingPolicyChecked: MxxwUjV4+Fn2U7aZVoI5g5CWhQOzp63xcfZYEAP+QXWeWSCHDRQ2iGYw2ZsBCJ6l2/7IP8PAOEz1phTZTTV84VXYBHKK4a06d4LkQYOqE/r0was5lM7HWcxhyj8ZJIxK8AuL79L6ZAe6DUvL1fo5HiOWRD6fvVFwZKkuraNIGF1iLLFhMp1UbXj5CyTyWMdotPgZb+reLg+JsbLWLMauBFwsNGml1c8qrSFg/TmDvw+zj7Q/+tZQE27r77IJ803CLhvyl3ceqC02Y0swFBCVH//k15GztHA0KrUQOTDyw3knTypwrQkwEjm1OszADLd/c0YG4rO4PiuMQVsaBA7qOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d025d00-d747-4800-e2b0-08dec03e9d8e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 00:33:49.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KpCFtRGkvCu7L2BK9Z/YgZlmv9E5HwXlnSr98TwU9Qjm3hDeRrv/UBOWFxhhWpk9Pw+I5MVlGNM0NbDXKoE1FVDAx5HwuU8GHClEoXFVJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7212
X-OriginatorOrg: intel.com

On Tue, May 19, 2026 at 11:20:11AM +0530, Abdun Nihaal wrote:
> The following two patches fix memory leak issues in error paths in the
> btt_init() and discover_arenas() functions.
> 
> - nvdimm/btt: fix potential memory leak in btt_init()
> - nvdimm/btt: fix potential memory leak in discover_arenas()
> 
> Compile tested only. Issue found using static analysis.
> 
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> ---
> Abdun Nihaal (2):
>       nvdimm/btt: fix potential memory leak in discover_arenas()
>       nvdimm/btt: fix potential memory leak in btt_init()

Applied to nvdimm/nvdimm.git (libnvdimm-for-next)
https://git.kernel.org/nvdimm/nvdimm/c/13fe4cd9ddd0
https://git.kernel.org/nvdimm/nvdimm/c/1a6b6442a982

