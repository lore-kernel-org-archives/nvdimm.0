Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792635184;
	b=2fdq35a8gHmtj+J+S0H3i95vbzAOTlAGiLm9pph17m9km6TYucrHhSV0BwNoAmTE8xdb
	 qOHpoGe5tSqZ6erkbGug4AxUotZSsiam8H3tISQB7patOHFLlqW6xOybzm/pL/vZrw6io
	 eUuDRX86kdMN36zppNoI0o6b+fMQaSjZULro92I6ZeQ34Sk0HhqjkPa/KllcXGItb4sM7
	 FpaSSn7AP4Y2D5/7uOg/G71hlWC/SmtLUG68SdF1U4uTG2BuWMK+J3kO2YO0QSx77d+2g
	 gpc1CuFpNX/NmZw0/Q+Xmp/rwUYyhy4lWMUUd0wZGRXqfdcJEhj+JhlLB07Du53ASRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635184;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=ysZyhBeeJEaryZu+J7mde5GQcbwPVEFKtV3OPaJGw/g=;
	b=DdCwNSfpjuROc3VbMUP5l7YlX2lbSFDCyNGXp6lEZXIiu9wf2n2CS/dJokNQJOOCMmyV
	 XQ0zD/BgRe2Z4xJX+/l/XXJ/T2teba/w6SBKqGWtxHpyN79JdWCLN1V3dTHvwso4W6Lzg
	 Wj1dx6uCabQUQhW7dYb397vtmiExVD5ppt4ibCEoj3KqzfkaVBUperQ/wdS+Sn+4HSu+M
	 em/kDMCrVGHcMhyscEhlX/AEHSeyDUYwwXaRuiH9EqZjB2OnuSA17t0+puvMfszcMKsGM
	 6+El+BBgOw+OpArhoyXgVSEgRqgr9ei1Ga4V6MGkWxn0l/7Iy2tI2ui/nrnSKwMm4tw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZkE1Ch5I;
	arc=fail smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE97606A324
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 02:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAE97606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZkE1Ch5I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792635183; x=1824171183;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=153aQjaAdp7KZNtlV0uTHEhYCow7HX9cvva8j1fzlIg=;
  b=ZkE1Ch5IclwCiorCq/JiA9+5l0B8rg6TDt+Q7wSxDqv+2Bjv4lHdk7AR
   6ixmoO5xFtGX7FNRNIilRBAyp03ipJQB0pUcnW7bl7l+TGM6X4ys7cmG2
   e/hlh59pnrq4HwKj2M8TP3GAb7IgAkEx6HvTOwYFZXrIwJF9RCybe9PoM
   CGnSyuVZmUK/5tkXC3UgbVGETjALcKoy6HLcmVDi9baVlYRNYya1yCOws
   kscDPoJKD4honT6xO50Ytqa6k4UoYTddjXmYtl3XRavJWz2725eGAYI5B
   Zis5Uei4MNvmMFcl+8BEYmnEZVCgAYZ6WCV8PLKwIE+7tN2ChVJPdep32
   A==;
X-CSE-ConnectionGUID: THfqtfUwS3+THuo7wBdgSg==
X-CSE-MsgGUID: 1Usq3g74SaqT5XUSLYunNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1408850"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1408850"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:13:02 -0700
X-CSE-ConnectionGUID: uY8OWPxBQoqTL4tqH6sgdA==
X-CSE-MsgGUID: G39Imsh8QNeuTYEhNAzSfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3183580"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:13:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:13:01 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 19:13:01 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.13)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:13:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3PpPRHyupFzPSIDkkmUu44wPctJLyhXXY0uEcpysNyHxrnKeAUJ9tMRN3gfyFUsfa4cJ2AKCqA0Tciq22HyVdrMhXCs3vGLKlrOeBJs/EJjAnARnMtxGiuiFi9vhl5QxGQMGvTZggwPDBPkz8uBE7f1Cs4V4FK7KxS4Ee4hOrKIbgZcc5a6KkDvkWUUjjhWUCNhgQwDGQK0tIbuzpGImGU6q8KnCiCL+aNqaiydVUWbD5I4+EJW0Mw0p/HI8/4L8fWlY9hNgwN4Tmh3b5iTGzsXEy/SAknFCxUoghUUyTlG0jc9X5yWurjU5L5MeU16O72ek8w1aEM0muWu9+Fgkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysZyhBeeJEaryZu+J7mde5GQcbwPVEFKtV3OPaJGw/g=;
 b=PQKg2GgDWUfjM0Zi9Md6vBDk59fqpZ6T4Ij/00SeRHq7HBvNg2hfid62MNucOMiXu3oi52F+hZS+IEXfJnFu8CZ2lkp2y07uB7hm5iFAHqTu/HsNKXc2H2rwhQcCj9Vcwh/dP9w5OMj+CKvUBLszOhhNpQWXqxcetkUhYfju23tZh0EWPl2hl98yVJ/Gf2FF6sYViLDW+RbxcKcnqmG1x7KYdC6saF/WWaBaIyLKRmxJn9CSHASjzG+RhC0tVLyH0UUgfDRRVN0vArPaBdQx9nvuBXjFj/X4VLbi2te7E7DOqx3uiwQUpMBtko/ynjqpyXveWHGaaKAUq38Ef6yXAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by LVXPR11MB9780.namprd11.prod.outlook.com (2603:10b6:408:387::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 02:12:59 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:12:59 +0000
Date: Wed, 21 Oct 2026 19:12:51 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 2/6] daxctl: online whole-device memory atomically when
 available
Message-ID: <atlxIz7uZhH9y_ac@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-3-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-3-gourry@gourry.net>
X-ClientProxiedBy: MW4PR04CA0253.namprd04.prod.outlook.com
 (2603:10b6:303:88::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|LVXPR11MB9780:EE_
X-MS-Office365-Filtering-Correlation-Id: d46e6e6f-5542-40ad-a818-08df2fe1fe55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|261009223027099003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003|261021121427099003;
X-Microsoft-Antispam-Message-Info: FHHiyFxrFb7ga+VXbsmSVe6gTtDZ4Xf0CDIULWZa4HmlJmHlOktAJd/lkcgu5XDBdece6bnb4otza64WU8J29S626qVLpgvJAtSZ77sAk/hxTBciZysyZfH3j6pLQwfFxdZdvS8tjsB7ye8YknsyZCNfQd7wqnJ55Vks7cA45s2nSWoy2PMtGctoM4t4lfD8NN1nqyN9iqu2P5t/Ggbb1RjVv7PzC3vIACJ55LDbVom3sqUVVDxDiCo2mN/vviZKnZlelCvk8y5/8oiza3W/aeimjyT6wJR+WtndHpmV5rI7X/A17Htp1l77qr3xqQFZucj5CY2i1lssoJc5YpQ9T7+j4IFIJjaRPDlY+lerxkHUSrNLxwb6NkhDiPQnC+ePPb6Do9ndDDwAkRcZRy+HCuHEIxJntE5RJFLF8SKy0UQTtvVzE6oqgTBqYqDOpndFXITVH3NKc0L33ZTXC24OeGWw/78WoR/2G0ZOaXims4q85kNKLIRKMvEMpWPbV6CJm6/RiDRulfTH//Jjz7d/tZ9lAqlIDBah6vYm7Xxd8oDkbJLyTAU/8+JT+OvJtEuF1kyXnP6VuBrROdJkX8fxlInTgVYdZadsZ5j7aWhghOPQ3WFcX+wqBN/BbigS4byYoFP+KTe8/vq8fdsvqoHCeeq4YSKh2YgS7BKWExwDS2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(261009223027099003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?idE5CN3Eyp+tFbZrjN27nhyMBDtxZfQ5Wc1XtZOY81ckDolRrrVbIs21T3Ad?=
 =?us-ascii?Q?u0H+3JscJ88ZWNqU5lTLr4eNo4OXSkSEXbo10LREPxprjrGgV13QzZW0VQlQ?=
 =?us-ascii?Q?XmHzmdgJswp4wulJGJ8rrmcoA0SeaN7Fw870bSVBb6u6gSLPQvYUVqguIsjN?=
 =?us-ascii?Q?w6qLN1FsW46NE100RilWgfHpi1tCla/UVJw1PYQEWxdwo2BzvoD+E7j24Eoq?=
 =?us-ascii?Q?3m6znMLV35hXMW+q5kVd4g/yqustv1aC1ymkEupUY9o9jlp/f7GOMQW3v8pD?=
 =?us-ascii?Q?XzoeWjrWiz7yzYRB4FzdHlx3pWSix81vBIzE31jc8a4fJWR3un2s9J5onb13?=
 =?us-ascii?Q?PrPbpSzvBU+BYAjirAJF7SkkpNl8qAXMX088GKz5DJcAatKgF3j2Pn7b7I4d?=
 =?us-ascii?Q?q8bQdA23ZEcnaWx+0TDs2ccEeikqYz+OjP1afZJzm4bU/E6x/X/0VFAantMc?=
 =?us-ascii?Q?rVd84Ef1tJbr+FYWV2FdEH+N2X3qmMm2YU4iBCbl2LGjkJDLXEsLQZTLM/Lq?=
 =?us-ascii?Q?ztGG7xb1SieqsmbRSX/kA3tpYyfyJfK0kgY4CUnincQBUPX++vEZ92gd9Ayy?=
 =?us-ascii?Q?wBFYGAfar2FIDh1k8dUuztb4I9pYRPZi/ReK6Ao4XSOVM6Zpa8yq66zH6aTi?=
 =?us-ascii?Q?yPUKE6oEBW44LJO53jHJ+2zDJ9heg34qZjk/I4DrLMnLpUpypweLOXy+7kho?=
 =?us-ascii?Q?VTAiysrBhgY/DieF1EkTUm7yt47zUgx+XYQs2y1+LcippyFoj0KYoHzZinYe?=
 =?us-ascii?Q?jAUFEHiU+OkQ0opwGrLbJcVONYvtjPkSqP8mjqMx8zBziKkX7HmIrKXVQN0v?=
 =?us-ascii?Q?yP886N66MgZkrT4Pae0QmaVh84E1PNhNVupxMP+iUyu75WUBPrUwn0pXZW+H?=
 =?us-ascii?Q?07Xu/qa1vT0/V+UQKnKXAIoYxDNbdU0PAwmVMxspyfGxug04dPzuqMjbn/dh?=
 =?us-ascii?Q?sBh1EsqLBEdCT1iysDasCgSwd1FnPnndfWZqIrO5T2SkkGyh9JYGbTQBfEJp?=
 =?us-ascii?Q?5ZBy0wrz7bPHX8xJM1VL9xsckln4CJSivm9rI7wvPM8Y7PoHWO3rseeuxCzJ?=
 =?us-ascii?Q?cTkKO7HueWPbjo6s2gAxhgIVhk8k+mfGLcQu7lfm7LpO/KnMK7wGeYyTJuvK?=
 =?us-ascii?Q?+t0GEtdt8gkgXFOExYWIKYPG3Lwt86IuTZWur7VPNgT7LbVcjaQ+3QBlDyLk?=
 =?us-ascii?Q?/tBW0t/mlK/MKxaI/70oVgxB3PxalDjajFOxLxebg0T2ULRBDvV10Do4V4FX?=
 =?us-ascii?Q?VHbadwQqcGjIDUPrfpIiw/v3emr5PNREi0LopDD1iGOfNjapueJhPOS4W/hx?=
 =?us-ascii?Q?vxohUoX73BMSFMNT9q5W69Vx2RJDo9mQav0EZ3Jca3glgcXC9fJMWb9M9nn2?=
 =?us-ascii?Q?2iV8VSVsOgUb8yZw9oQ1Kt6YqDl/Lf5gS2QQ8emQw+d0SMrCC5mScHlKyusQ?=
 =?us-ascii?Q?CzbaoiB6Eevtw587ra0tz7MelawQtE/YT+n7TsGs/VxLf96wCdpq3VlHbDH0?=
 =?us-ascii?Q?JL9jNNnBN4FouAQbenRKvAf04diYGVWyDawb3Swgla1BRFERBHwgMYGweqGf?=
 =?us-ascii?Q?gsc7Pdke0kPd3gYaUDjehjbsCrKWai9d2B/cBOrhoMo8jfq/AZXuUi3kBi7G?=
 =?us-ascii?Q?LTZErgsY4sxaBJIAVaDfZ78Y3rTv5xl12GAOEW5bViQrXHWUzpG3IG2eEyhd?=
 =?us-ascii?Q?lu1HfocTnFxZxTR/VdVgR0cpEhQhqHdJ8GHAXb/h84oqyQGdJW/BrWo5zsi9?=
 =?us-ascii?Q?Uh+fUNHizs1REVNLNYw0ZvRuMSJTmME=3D?=
X-Exchange-RoutingPolicyChecked: as/VuWgJPSSjtIaZvAJlGTcm83CX2zNISGh7ddW0sVHRj8Xj4QMWe4SSqDFZmdR9yXaLxt/Ik5B6gZHgEAqxIDqsZIp3gxOK0XigwC1Scpx268zMEM/gySOCpGqmxiyn7+JFsLJaIcyzyOmlNCYwoV44xn41nw+dO8I025TsYlkKAoxjUSQ5qC25fhzYSDjibL7/82J7KAdzkLStHMcijcdibRcbSl0/15e3qcZZ0Ap1Q0LwbKeN4g6fnJSlUJJIoM98psCjDUK7iz8gH32SB9PUvOT7aKKYMOxZ4FKK4flTig1PSK4slIwtydL/uCe9I7u0jhXuZfBIh3Skr/WK5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: d46e6e6f-5542-40ad-a818-08df2fe1fe55
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 02:12:59.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFPAFKv3CVOy4ipdcPTkEnM5Mdsg0A3NlkjsVUboY7fDFCdp2RYmRt/cfU+iY+1CjcYIj4DA3liPYhllv4hmvgnVJ86EE1isI7SKxQHtHDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9780
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:44PM -0400, Gregory Price (Meta) wrote:
> From: Gregory Price <gourry@gourry.net>
> 
> When the kernel provides daxX.Y/state, online a fully offline device
> by writing the online policy to it rather than onlining each block.
> This avoids racing other agents (udev, auto-online) that online blocks
> as they appear. The kernel only onlines from 'unplugged', so a device
> in 'offline' is unplugged first; if that fails (e.g. no memory
> hotremove support), the device is unchanged and is onlined per-block.
> 
> Memory onlined by another agent is left alone: the 'offline' case
> re-checks that no block is online before unplugging, and losing a
> racing online falls back to the per-block path. A small window remains
> between that check and the unplug.
> 
> The per-block path now fails when the device has no memory blocks,
> rather than reporting zero sections already online.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  daxctl/device.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 105 insertions(+)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index 47942f1..fd84799 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -510,10 +510,99 @@ static const char *parse_device_options(int argc, const char **argv,
>  	return device;
>  }
>  
> +static int dev_online_memory_atomic(struct daxctl_dev *dev,
> +		struct daxctl_memory *mem, enum daxctl_kmem_state state)
> +{
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	enum daxctl_kmem_state target;
> +	int num_sections, num_on, rc;
> +
> +	if (param.no_movable)
> +		target = DAXCTL_KMEM_ONLINE;
> +	else
> +		target = DAXCTL_KMEM_ONLINE_MOVABLE;
> +

Hi Greg, 

A couple of things here...

The atomic --no-movable path uses DAXCTL_KMEM_ONLINE, leaving zone selection
to the kernel. With memory_hotplug.online_policy=auto-movable, IIUC this could
place memory in ZONE_MOVABLE despite --no-movable.

The per-block path checks the resulting zone and fails if it isn't ZONE_NORMAL,
but the atomic path skips that check.

Should this use DAXCTL_KMEM_ONLINE_KERNEL instead, or retain DAXCTL_KMEM_ONLINE
and add the same zone check?


> +	if (state == DAXCTL_KMEM_OFFLINE) {
> +		/*
> +		 * Onlining requires 'unplugged'. Don't unplug memory another
> +		 * agent onlined meanwhile (a small window remains).
> +		 */

With this, a "reconfigure-device -m system-ram" may add the memory twice.
First kmem adds it offline at probe and then daxctl unplugs it and adds it
back online. If that re-add fails, the device is left unplugged rather than
offline.

I get that falling back to per-block onlining would reopen the race this
series is addressing. Could the kernel interface support transitioning
directly from offline to an online state instead? It seems that would avoid
both the extra hotplug work and the left-unplugged failure case.

-- Alison

> +		num_on = daxctl_memory_is_online(mem);
> +		if (num_on < 0) {
> +			fprintf(stderr, "%s: failed to determine online state: %s\n",
> +				devname, strerror(-num_on));
> +			return num_on;
> +		}
> +		if (num_on > 0)
> +			return -EAGAIN;
> +		rc = daxctl_dev_set_kmem_state(dev, DAXCTL_KMEM_UNPLUGGED);
> +		if (rc < 0) {
> +			/* unchanged (e.g. no hotremove support); go per-block */
> +			if (param.verbose)
> +				fprintf(stderr, "%s: unplug failed: %s\n",
> +					devname, strerror(-rc));
> +			return -EAGAIN;
> +		}
> +	}
> +
> +	rc = daxctl_dev_set_kmem_state(dev, target);
> +	if (rc == -EBUSY) {
> +		/* back off only if another writer onlined it */
> +		switch (daxctl_dev_get_kmem_state(dev)) {
> +		case DAXCTL_KMEM_ONLINE:
> +		case DAXCTL_KMEM_ONLINE_KERNEL:
> +		case DAXCTL_KMEM_ONLINE_MOVABLE:
> +			return -EAGAIN;
> +		default:
> +			break;
> +		}
> +	}
> +	if (rc < 0) {
> +		fprintf(stderr, "%s: failed to online memory: %s\n",
> +			devname, strerror(-rc));
> +		if (state == DAXCTL_KMEM_OFFLINE)
> +			fprintf(stderr,
> +				"%s: device left unplugged; retry to recover\n",
> +				devname);
> +		return rc;
> +	}
> +
> +	/* all sections should now be online */
> +	num_sections = daxctl_memory_num_sections(mem);
> +	if (num_sections < 0) {
> +		fprintf(stderr, "%s: failed to get number of memory sections\n",
> +			devname);
> +		return num_sections;
> +	}
> +	if (num_sections == 0) {
> +		fprintf(stderr, "%s: no memory sections present after online\n",
> +			devname);
> +		return -ENXIO;
> +	}
> +
> +	num_on = daxctl_memory_is_online(mem);
> +	if (num_on < 0) {
> +		fprintf(stderr, "%s: failed to determine online state: %s\n",
> +			devname, strerror(-num_on));
> +		return num_on;
> +	}
> +	if (num_on < num_sections) {
> +		fprintf(stderr, "%s: failed to online %d memory sections\n",
> +			devname, num_sections - num_on);
> +		return -ENXIO;
> +	}
> +	if (param.verbose)
> +		fprintf(stderr, "%s: %d memory section%s onlined\n", devname,
> +			num_on, num_on == 1 ? "" : "s");
> +
> +	return 0;
> +}
> +

snip

