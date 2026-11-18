Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794962117;
	b=U0LUMIs3UVsgxYmLKPkvqiCcbZfULW/VKb4B0giGVVB9xyKI/CZoulPwR0DZtkYKvKZu
	 Hj1ddE6zff4pi9p8+x0WjX+h+XmKendNRxrKBIHkwWVFNKvVkSdMVsMTnfw+rY8njhNh8
	 CBt+D5D7jDyEusrIkswFdtaBh+khe1+YIMjPTfhETAV91FP0sAZYcPNx7WPhh2g/3wCG4
	 srXrlcl1LO6Ws1OEk8/tRK/WQEPX3LHEoka1miwJ8s5iAKlIiMeZE8O1Q3uz+mFX+sg0P
	 6gZQj1SDg8oo3aa4VVF+VJmrIs/M2sjW3UvDZl3Zo5v2ezKhYI59ITXZlfFmDFO4gCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962117;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=FF+EfbetL1IWOyglKxFgM3h1WxF4tOq6uLSFG4vphl8=;
	b=F5hOXiPmlXv4/1vmC1mAz3lBEMRKyErUyejcmesacIxzSD8mSePzOTjpPFDk1Gig8JPg
	 hpNXAKccZtzQOoXr8Ry4eAkxCnqvA2Ln/7wUqMrRXyDhiQNqyL8aeVBBIuc7VWuN4GFN1
	 agH5LehAz2MnwcnKoEgab6OPoHzEFV1d2Cg5YOGzcgSB5v1gPGYw4A9l/6hxljlJZmcSh
	 /eAznKKrVE9AMylqedjcEah+Btxi1MpAkI8YlnBDbbgxDiEGUr0TBhrcGwsBQm5hwoA/r
	 6IW+r4WtP1oQo6IUOnWPNK114SCGsKGKk7zF7MkB87F4QClTDkXHRiv1stX1EVVz8jw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=c35JLMVR;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=XCYZ5mbC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60384606A31C
	for <nvdimm@lists.linux.dev>; Wed, 18 Nov 2026 00:35:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60384606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=c35JLMVR;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=XCYZ5mbC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794962117; x=1826498117;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jhC9CH2oBpAn3cSRIJdJsr583eTwk2Ouizlv1u2XePo=;
  b=c35JLMVRND/HSlUuZ5zyPlFserypUspdc1WfllettPs0aXk1mb3J+VK0
   aIij2rCKe1mRf1v6vaflJeO5NpTEIptV14LOYfq3W+K8nhxteTTXPDIUf
   6XRXwQq6JZMPaGTS5dIZ0YO6vbGgVGQah5WZQKxcyJ0LQleoHlkgzfqww
   wghcQ4qNTOYpaDj/zPQuAxbGlwd01Cx1FhNdsgPP8ejDd4suAyf3sjZ+d
   Mz8ESYQaXVmw0Gjdx4gJozstNbxYqPGcjMyQ6be1p+S/k1xrjAxo3X0Fl
   LsDFJb6nYRRQ+hPU4JbjZnZ3GSww7nxg7bq25jdn5carSbZrL3E2f60qZ
   Q==;
X-CSE-ConnectionGUID: ZtDU1T+ASga/5c6/041SlQ==
X-CSE-MsgGUID: /K0mwMvKTBydHbWvW9QTew==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3747548"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3747548"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 16:35:17 -0800
X-CSE-ConnectionGUID: gbBdXmaRRIq5m3/sWrKjgA==
X-CSE-MsgGUID: AXQMdIweTKumUYGRsnXlvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="9868007"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 16:35:17 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 17 Nov 2026 16:35:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 17 Nov 2026 16:35:15 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 17 Nov 2026 16:35:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NFjdmU21JK6/7xykoWXXypUcpmsyZwke27Qz6c0GgbFfYRAMBncU1u7giLpPLrPNDmvOMbJuHAwXVEebeSrjNfkxrWlLQgcHC3ytPSfw+418Wwf7h5L9bdCQD8S6eTXO9AIvV2FHvGBdJ0zSgEaGnuMFryJT5/PGPXkcA2NiMf5baWRBQLqW4f8d1SQjnEc2mUIlzChb63b1QiqtqIJJu93TqAlUeKRk7I7E5wDiKeLYnd8fzFuubG/GjpUaEnsf6C5y8qsX8VFoIW6zjy/SbaopP7iC7wLMxoub7tvkDrWt9WE6TRR7rR/pXj090/fWo36HzSe4f6Wro/yamEib7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FF+EfbetL1IWOyglKxFgM3h1WxF4tOq6uLSFG4vphl8=;
 b=zEzsfYYlIC9zKrWSlZop0NbRhKlPCqAwBiePqZsvFEsHSjpiqYFvLO8zh0RGOvpNc84JWNVyQZV6/f96GERbX7hpN4flBFSnvCe5kzZzwiYVphrZYW4k4YW/HxgoFI+iUv5UgHHqGH9rq/CFb6LiMWDtZLHKV4g5FftYEOctg8vVxb6+c7AWLSzl3mXJvmPrGRLSNM46tqSiZCWK1u56mLBsYcpmZRG25raYLxdCf+lenOi7AIsTzqNMpNM3I9MJx3Y0N7gS1mKXm0CEyWsdcBkFKU10n9H9QPRi2LmQzsjWw5Jx8ntggnjuYHVBHgR5KBYPLXQXJuNTrvQB5D3X/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FF+EfbetL1IWOyglKxFgM3h1WxF4tOq6uLSFG4vphl8=;
 b=XCYZ5mbCSmFpQBNTMXno7Wo8pbfV+0YNQ7BL5rgFApA2HofS/ILE+MDp7vmHcnoSZsjNzvr+ZWx08yC3R4jDv3PgNvEQGCgabzjyTRpViujXtW6gYjcgCIzUGtaq21DMDaChwdsYW5K3LwpxSgnKN7yRjmj2/AflrYaqp8vKYWA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DSSPR11MB9641.namprd11.prod.outlook.com (2603:10b6:8:377::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 00:33:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 00:33:29 +0000
Date: Tue, 17 Nov 2026 16:33:26 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nvdimm/namespace: Nest mapping locks under the bus lock
Message-ID: <avzyVk1aDp4cNhrR@aschofie-mobl2.lan>
References: <20261117223116.3478672-1-dave.jiang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117223116.3478672-1-dave.jiang@intel.com>
X-ClientProxiedBy: MW4PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:303:8d::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DSSPR11MB9641:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d2b0a8-2355-41b3-6cb2-08df450b90ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|6133799003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261026121527099003|261021121427099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info: kW3IA1DfK9+sSKDcyC5rYnyOBQmYxglLIc4HqzKaRbX3ZAo0doNTQ4uwXT1rxkz5rfQ44mi3fNe026nHLSYqDxF2flnuTL4xTCoP/FLAPfpcgb5+Hs7E4cA8oH2y7kYxQxivfmY0H6a2J21xomiTHEbFCyi0a1bhb1UCPk7zcRCjD8XHhBzT9OovIrCniVM3XNuBaQNfnr8adqZWMiM6/ra0uoKWduzg4wlnyt6L3Ua4BF5xIkVraR0gQbxUIR8ZFnNb0t0zUfrgqv1oXp/4Odd/aA4eZP+/R5gEb1Z6qZoqYDTIqjsUyXJSZFoWHfjLZyp9qwy/8tofFvzVWd1eLTd85VD7ti38b/Ao9G9gVY3l8XK74wOOXRoBQ4RmXubI/ZAZHcGejN6AoBmYQk0mSrRAYBfhLzg4zarstg1pHEi+M8dbKZwOuqL7tM0Y3PigLsrDiPg3xIHSzrufspOo1j1aRce0ciPTTxsxdqem+PBZcYz0EMObvVwVomkyeOgY3dccz4ocPm/70O+Z+vWwelJVWicpZSkPfnEvoSI3P6qW2mK3B19frhOrQ0YhwFRQ9eyTMse0tE7t/poaOx/78wy+kHUa0uqU4Hf1kcy/dDc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261026121527099003)(261021121427099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Y/RfUzZsRPTtiMC8mNwbuHWTHeAYNGF2KXmtbS/MYwOum/WZ901fS2zfN1t?=
 =?us-ascii?Q?BzKQoO6ToBTjwNlXNln4JtfZl4di+7M08pzgVQjj9kgrmV6A8+1LFk/GF1tM?=
 =?us-ascii?Q?tBZzU6jPRjtsSxXuOERKjhLx8KLvXf9xILN3GmMfbkx+O96zOo5vetQHFSkY?=
 =?us-ascii?Q?lKOwyGszuEWAEIJXuO1IJFEjoYORt7Ry2T7I5q0nOan5tPkCrBSYM9xbAE/C?=
 =?us-ascii?Q?3IIEJYhm7AVzAKQM/07LD/X6y0WyN6ofWgRcO4ALSHlrwURlGJ2Y4krE/nl7?=
 =?us-ascii?Q?RbpmZkRDfyIo3KHopE1ZHU3nuwyq79IYfU96dB5VoGUITzNz0twXIeLLYz+S?=
 =?us-ascii?Q?tpqTh6BeoPmslt7aeUNdUO/UQGc7zXPbVP5ASY61BEXK0BpPbH5/2aLqrGW1?=
 =?us-ascii?Q?DEJaygHzU89hoN/TLEFa5mNHhXaqj5GFzdKoOkYUuyQNcexzoZtzwHb4HGwI?=
 =?us-ascii?Q?pzfTIOGdO2S/Bpfpt4EgZNRge4IB1HFfV7m6XOiYKkLegS3SO6CMlOZeEMyS?=
 =?us-ascii?Q?Vl7Ivfq4/vh3U9DK63dwIOT2reYp3eUArmENahjJ1CewjGqMVYk1U/a8H5p1?=
 =?us-ascii?Q?OyaOMVwmLdnOSo2I8mlcyPE+hlRk5xJlCjFLXnaiQRCKtsS/O9zOTSD3ROIR?=
 =?us-ascii?Q?bIuGwPU299SQLrih/girC51ET5neQxlx1+MA41g0lFwS4V4U8yD43cjN5uTG?=
 =?us-ascii?Q?ByN0JEi6k9ux76g5Uu+Le6X2sg1kUDs19hJArCTzH1iqIGT3FkiDGvmc397G?=
 =?us-ascii?Q?vsLVQE27NXCwX+E+EU838RLKs2iRM42v9gm15KXUDefBckc7Jog1S3iGoGf2?=
 =?us-ascii?Q?OK6VTo6EC08GvnrG3P8sQlShmjBg9HV/lRs2eKVmmkS8kU5MmEBTe1SBM3TZ?=
 =?us-ascii?Q?v9MLgI/I1RAiM3k5iPrxl58k/nEZT+L+Jekm5RBHPVJkCWSL14kPXb+rD+Z7?=
 =?us-ascii?Q?JKwEIfxvKj6r1sWaA593Q8X/+ZvW8ZK/sZCyMH/pKhwc5WJcu1bImR8LaSCy?=
 =?us-ascii?Q?qqeLNmIrssUGAuiRrXbkQvOMdcG1GF9MWpaMm9oQr1bjOon/fDQKAMEHgyW6?=
 =?us-ascii?Q?bxM6cw8Sl2UpCRhLgK8t99kwYcdXoEM1Xt6tv1m8b2dYQrf0GCEQquFuFrFV?=
 =?us-ascii?Q?ccOv3G1F4OMv++aqDj1es/Nv+eBFBmfBd6/gBpQxJGlZ1gbA+adYj4+rKi+3?=
 =?us-ascii?Q?J26PoqCq/IvcxUAZECFCESvN1wV6amn7sdWVY0iLolNHz/bN7U3jUIUni42C?=
 =?us-ascii?Q?06FEwT9m7zpUcVtxCp1bmpSQ2FlkHNXpmMHV4VUoVDCcPSv004q3J4tTSOMB?=
 =?us-ascii?Q?10ZMPDgAecXF070Qs8mWCdpZgWH4AZKfGTkAA7sjFd/xx1nYz2ARRTApcIbS?=
 =?us-ascii?Q?9QtkG3OQ3m9bktkizzIRQds08sx7p22roDwHgJUlyVFd4AIxLEzFd2Y8YNad?=
 =?us-ascii?Q?MBNpSBxRM42k2IEBWSjjgwO774vmFEDAhJchTTyURgd+1iC6mTcxQpKZxrOR?=
 =?us-ascii?Q?v5E9pzue0pkbGYD0Up9y0pg7Trg6ewvz/XASOf2Q90fLIWa6UcmH7L/MI5q4?=
 =?us-ascii?Q?fYOMZyQ8Eg0MwQ5Y6z/OOtKs85PXsU9QQuW3KhlloJ3IHiWJ+YVeGOrcxv6r?=
 =?us-ascii?Q?Yu9sLm19ZSlOjCESsAqB7EA4uz8pjgXwxUG2zYi2JyM9CPR1IpkgWD9Uprle?=
 =?us-ascii?Q?sCQ3yGSqL6iJmJl67Q6I7DkPFNqy7IG8z7NSaJX4zYUZ88UkYcErFNGkmYvS?=
 =?us-ascii?Q?FOBoVKlIrWsi3RGh5wpS6purEpsfQOs=3D?=
X-Exchange-RoutingPolicyChecked: LFFWwaAzvIfbqhONWG1y6FnHW2h3uudR6p3xRc5yViG6rqyZ1zV2p3ldkKbKs5Ai/hjeX4CTkaCC0cBvuHHlBE9aOACESpg+3FTdmzdfpIz7PpIEdYV4r7GOLhjBWbjBJeSWpAego19hcTUbkDKzybMHKlfSh8uMlsirl+QIEOBohSNkA1kt3TAm8iomXQ8Oruzo+amLGCqpL452bG+f8kdJcIwxpCNMydLPOLSbQfKHGffYqLFFAKKG2xoF/A3oMfzF5RcFUsg/buANJjy2vdS9YgRDqjRq7fQm1ZNNbGhRSKhAzyuI7yhOxHP91W7BY1LxogcuQx0Y9c8bJnMwrQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d2b0a8-2355-41b3-6cb2-08df450b90ec
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 00:33:29.3355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sqqget8rb1PIiA4i7t6CIsgIECOukX/Lwnx9YltDoU2wCgYlb1Nx2pW0+ISBFnRPhWe8OXdGn+AlEvnaFPmdj8AVS29UM3tCIH0lIkRviDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR11MB9641
X-OriginatorOrg: intel.com

On Tue, Nov 17, 2026 at 03:31:16PM -0700, Dave Jiang wrote:
> create_namespaces() takes every mapping lock in a region with
> mutex_lock_nested() and uses the mapping index as the subclass. Lockdep
> supports only 8 subclasses. A region with more mappings, such as a
> 12-way CXL pmem region, triggers:
> 
>   DEBUG_LOCKS_WARN_ON(subclass >= MAX_LOCKDEP_SUBCLASSES)
> 
> and lockdep turns itself off.
> 
> The caller holds the nvdimm bus reconfig_mutex. Take the mapping locks
> with mutex_lock_nest_lock() under that lock instead. Lockdep then
> tracks any number of mapping locks.

Applied to libnvdimm-fixes:
https://git.kernel.org//nvdimm/nvdimm/c/5a277aa7eb4d

> 
> Fixes: ae8219f186d8 ("libnvdimm, label: convert label tracking to a linked list")
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 557fe0cb43e2..3aa0a9026efa 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -2031,6 +2031,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  static struct device **create_namespaces(struct nd_region *nd_region)
>  {
> +	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
>  	struct nd_mapping *nd_mapping;
>  	struct device **devs;
>  	int i;
> @@ -2038,10 +2039,16 @@ static struct device **create_namespaces(struct nd_region *nd_region)
>  	if (nd_region->ndr_mappings == 0)
>  		return NULL;
>  
> -	/* lock down all mappings while we scan labels */
> +	/*
> +	 * Lock down all mappings while we scan labels. A region can have
> +	 * more mappings than lockdep has subclasses, so nest the mapping
> +	 * locks under the bus lock rather than giving each its own subclass.
> +	 */
> +	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		nd_mapping = &nd_region->mapping[i];
> -		mutex_lock_nested(&nd_mapping->lock, i);
> +		mutex_lock_nest_lock(&nd_mapping->lock,
> +				     &nvdimm_bus->reconfig_mutex);
>  	}
>  
>  	devs = scan_labels(nd_region);
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
> -- 
> 2.54.0
> 
> 
