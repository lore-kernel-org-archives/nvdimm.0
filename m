Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795545392;
	b=uieI4nKnN83iwAB3t591TSpP41RFx6i+R3fXMW3bGyafPjKMOqARvoDaWHSdy+QdJpwM
	 i9nrU9DLdjVAldGR4xT0BNcE1iPpCJJ4zcjy42exKjELSc9p6QSzz0zpqMxkmiiRrfBxb
	 KnuA6/ok+iow7wteub4wO1dg+NL31Rp0lsawPW5CQP7lEt6hQ/UsUrEH8Tjry2GiUXO9t
	 ZhbAo9CGPZc/8Qk3Ooq70zIAKoeclbBz/I/GelJb/5h+7fw9bHM7E09TiDmowtw4jELQc
	 MCy27joU+JmMHeePUsZsMLnqirG/CqypyESa7EBEvo/Rz63+VM4MnujIcvj5ZHu3m0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795545392;
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
	bh=dKFoOVLI+AAA2ryYfx+gv9Pe6LoSXzWmRazPoYBIAu8=;
	b=QL6JowF4Kl/HnzUnVUqw7tm3+SvO5pVh6UqeXR0p4NaYO+o16tJbd7ZwbkWR49zvFMni
	 x3GKp82WAcP8Z+fyrU1/5bPxLsGSFBhvACJLyfgFqHn2Kk35jcGj/xoPPu4s7JV9ROGq+
	 H9WDPwS3J/wxEmARVs0lBYVMBz+wT1X5OTX52282sSDtiLdVTRFIXZSA2vKsN3mk2P1JY
	 KdjIbXhpFnF7x8CG0cXzBAByyDiSt+etufyo9lMyYrgCCwfKk24phhiZyyb5hLbnApeaZ
	 Mv4GvBelqgjB0NRBE5sV1pD0HLkcZmU0nYRgVVrn3EvLFYlBpf6cvE8H+CBcEU+/V1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ojp5G8ZC;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Jg5Nc5fO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53A5606A321
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 18:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E53A5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ojp5G8ZC;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Jg5Nc5fO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795545392; x=1827081392;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0tDw22Eo1EQxqSCIJCuh/epsC7BupIO669R1z1ELYiM=;
  b=Ojp5G8ZCw2gdgaXby7eztCaPwifuK21tUzCqvOLEvbN+7qk9qbk2EDFI
   c4qiNSBgJ8iZYBwb19pD7UGgoHNh5WaYzeNDNLf8IGl6uV6FK2gVjQnqW
   DUVlJWG7hVEpJKBAVW64ptyEzzhn8XB6zgp/xPeQf2o5zCyzuJbDlU+Gj
   RnBUj5rPS/1YgA4/jjhtc2HewiMmQmUGb4g++9qfSoppVR5jdOu/gWiQC
   1D6PKcK3XPv40R7NgU9PFVpCl/N7efEHR8EsZ3DsszOOxGvfrNYikpSIv
   mOoj/+tNxMi8ZphfqPwSz3GuDPu3lC4ukRQOOIluuF9wezzuCba9NFxMp
   A==;
X-CSE-ConnectionGUID: ErCTbRdtRtme0YuniEellA==
X-CSE-MsgGUID: Dha/OTvETpelNOwPHWJF/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4299383"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4299383"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 10:36:31 -0800
X-CSE-ConnectionGUID: H1DWiwNKQr2zHNIMg2UyOw==
X-CSE-MsgGUID: xS5OYJqSS3SnuM+oNgS12A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11764343"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 10:36:31 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:36:30 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Tue, 24 Nov 2026 10:36:30 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 24 Nov 2026 10:36:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bLifpn+hoJtp5QscbpIJ5EiHmNdP5H18y5O6pAd/bSc014aOLkAzaC1xtnaXNCi6V5cKJr2ujErQB5Qt2fFRYVPhIB3vdhFCMHpbo0a+FZns6ApplsjdKIdJSO08Mt0KZGOl3MvWUDqX/MVJPZWXvhbIjt3d3ACt/iVTFYQmEmZTtvNMmJNsjTxyM2woL8ZWi456gAWCU0zEGkc+ocbx26Cvj9Ejoif6NOtJSpjXvdxA5ZU0RrOfD8inI5t8PX/cZeKBHdDjG38TIpl/MFgcnityWwXI7b+iXHOJSJz8LbstKEivkLeon9nXXRmyJT0k2yQr+G3bdjlVnhpk42UXfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKFoOVLI+AAA2ryYfx+gv9Pe6LoSXzWmRazPoYBIAu8=;
 b=Vl9yXuoCjXsnASRwm0h7HnEvEjtQGLfWtkffahtdxIoM/0Y4qAZu5vQ5eSM1P4v64vQot3c954Oaqu0LV/lgnBlRc2vcALJyTb/VIzZlGU2F6JWwJRtE0jD3wJCtGGnDku9Ir1NumVTThITomXRyfszxm4Y4LFbsc7ZhvI3UFh5hC4U0cAqzknhu1cZo8APMw+9wrMT1g3sAo1fcDj1RYSStkAKsP1hQuw64bo7EuGmaPd1l99Lk0jlKqZesg+1uW6RYd6ejJs6TcOB8MIY8nVZU567NBiNXKxaydou4d2hos+LvzeqPdahbHt/eQbUX28X6kMrb+oyKSP9/Edc3Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKFoOVLI+AAA2ryYfx+gv9Pe6LoSXzWmRazPoYBIAu8=;
 b=Jg5Nc5fOgzicuvIRct/NrhZ5EtLGW9mJ5ULtQbDRO9P1KA69l9etPb1RXbcFAkCj5mJ+0HT/N1dIdEC7q56nCanYDo+WS8ereWqKSMxQ8VVviKpFeYKYkJHIT9bLqgurHcX3ubAkK9nrnF1SIWfH+NqYjZSZ5WVITzJAjbUI6Bo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by CY5PR11MB6091.namprd11.prod.outlook.com (2603:10b6:930:2d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 18:36:23 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a1fc:97e0:329a:4aa7%6]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 18:36:23 +0000
Date: Tue, 24 Nov 2026 10:36:18 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, "Jonathan
 Cameron" <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny
	<iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Fan Ni
	<nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, Richard Cheng
	<icheng@nvidia.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 02/14] cxl/port: Add dynamic capacity options to
 endpoint decoder mode
Message-ID: <awXZItm1EwH2Qd5i@aschofie-mobl2.lan>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104230445.66625-3-anisa.su@samsung.com>
X-ClientProxiedBy: MW4PR04CA0349.namprd04.prod.outlook.com
 (2603:10b6:303:8a::24) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|CY5PR11MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7460fd-c53a-4bd6-1a22-08df4a59d6c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|22082099003|18002099003|6133799003|261009223027099003|261021121427099003|261021123027099003|261022105027099003|261026140227099003|261102123227099003|261022075727099003|261026121527099003|261028144727099003|56012099006|10067099003|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: 4Oy+O9S58QSTAL0BizIx51tOv9eIc8arEwPawyhavNnqwh14JXoEH9Ne/Uq3HkQaNrgCwhd7Z3O8rNBjjr9iaNIfwacKfecM2nzkS9swco8RE0KFGhAtmtxUbEELp6dP6S72gbVsa27RiGXGH20IK1yFWTDEnnekN6Cjo3r/q5ChPSD1Sn19OBxhsL+ylkzkPvR9pGwMCJqUCjnajy+qla8H4iHomB0couR4t2YSqTbgy8rqpHQxt6+L821zusJXNfXbb4r4hUa8yUXzc7lrZPK3NS9wLnxHXZAK8ARKAKMBMNO8t3Zp2BRH19x+96gvtMkztfHkKxds2zV9Jidh255zc8Uct3/OiKiTreMnSOHazX5UUx/1sIngpBxLeo2DtI3Ce/z50ouJnaPSlCZ2yM+h84t5l7hFfv9urkEhyocl2kMZghmLmkaOo891AU3XSNjiuatOsTUSaFVlNcQ4Z4XbiMIcIgwg6jrHkC2qkQAaObKeGWdUm7aVaRKDui52juJXsRnMUJyyiURNj9NhiMUDrAud1uyuSG3GmGWtggW1ADql0SoaOUgCE6xpaP7UCc0o5nfGEVDAYeoOMusy24yGh/vaypJQLII971TWaEbwsUgay4VaNFSI60pyMmdqeYzGhG1m7AZg4FExzwdYGDFQoqLUdUG0R1HbgAaxGrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(22082099003)(18002099003)(6133799003)(261009223027099003)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(261102123227099003)(261022075727099003)(261026121527099003)(261028144727099003)(56012099006)(10067099003)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wK2a/5DA6L+rqoYGlwNJvDplpBBYHnDYxpYiJ/ol5OFm6dQgqwO+wJ3nD9jA?=
 =?us-ascii?Q?pfxiAiqad/4DC290hsS0t2nqjtBEFMhiwlFcUypvayTmZWpoPHIz5hkGKJ6d?=
 =?us-ascii?Q?X7U9jlkuj9BKyIweqV0uVR1LxG4eDzYBOf5ZtNYfWXBz+74k2yDvBT/L4M3R?=
 =?us-ascii?Q?4M4d2WLBiX5k146TpdSc0iJI9kLS973efZ318OE/EG3L2GlBCTb9OGCxrAdp?=
 =?us-ascii?Q?O80pH+Pb8lVa9SyhgFueGrhJIZ8E38HMUws6oX3vJVVufZiHYKUHyxNmn/3z?=
 =?us-ascii?Q?zNzazLYGcdyfLrN6PSIT2wM2BV6Vvj66l3aIpzcj0mVx1JTbfQXs+1PuopIH?=
 =?us-ascii?Q?VpmahqqBRYc0Pq5yBvvWWyN49GQuEwMGZqZBy81dHCCrMOFtKYu0rkQj9aXr?=
 =?us-ascii?Q?EmHQIwih0mtrCCuQxSN3hTyMhmO7zY7+SH1DnGseHgKZrrOzkbhbXviS7O6C?=
 =?us-ascii?Q?tK8Zubql1ZMYXlh4jKqEmM6Njy00ORUJJ0pbZ/mQoUbzw02ulnfAB5+Ql+4b?=
 =?us-ascii?Q?go3gtcSTFhia9TONac75lgF3iBEO4Ydab2e6f1+I3Z9dvwMeXOETQEXRYDjs?=
 =?us-ascii?Q?H3Q6SAi2rnG5IkdB/mgdKbypGP8DBFRNUQD/YdVF1tJMac5TBvY5DWXO/vOZ?=
 =?us-ascii?Q?74mUL0My1M2bv2VuRhKY/Dir3JwHk0veoId8p9htQhg1kRcL3TaJR0pFVxbb?=
 =?us-ascii?Q?PIJTdll2ga/2c1IjGdbaZ5fSSXNgWnmtpFyWeInfp4AZIMSbGLlkMoCOxUVN?=
 =?us-ascii?Q?sY1cMnPGaJQdHnTocuwCfK3eNL1KEPD/bFwyLqKnlLO4AVDPZSFhRHDbamS3?=
 =?us-ascii?Q?zdoCUUZ0rWYWJFZeAo+99QNx5soS9iCJDdshXo3zIy7iUYRYP10bST3IZkZ2?=
 =?us-ascii?Q?pXpZvG7ozOYDTANnAkdeUICDcFCDstKNVIN5BwK7JAyUAPCHx7JrLOOU9bSY?=
 =?us-ascii?Q?dGlXe5qUOzDHUrIKtCCLIMSPQAzGGAC2RxpPk/e4lw1UHWHoK7viuC2MoNlu?=
 =?us-ascii?Q?I2k28I5OkycgKf/ogs+l3BSV5rwAzJbxkWMI63U0VIxEYnQkep1TMeCu8DLx?=
 =?us-ascii?Q?JoiM9UZfjP49Y+yrV9QQ5ix38RXT4yE+YMryQ4gQKHnpEwaJKpa3iKX3fQlN?=
 =?us-ascii?Q?D8SpPVm4lxmguv/58cmyXHdePHLflbRNqqBwWDWY7hCiuf/GLYf5E5W0m/ps?=
 =?us-ascii?Q?CeGPVaiKROSl9kqn26C55uz+pt+/hL8uRf/dMYqBhOV5w2ZBYai/IF7sxtg+?=
 =?us-ascii?Q?aBWFm2kBYy8p+y9Zq+cwLzYhkwD5Onbhui/pvOFItAw1dZbSm3756HKbQDWw?=
 =?us-ascii?Q?5D9OcmCdWF79NMDXgWE0WWgeLLwlW+XNP6ktaexZgvX3mMYxz86IyO47drDv?=
 =?us-ascii?Q?5aytBAsi3pnhdPSSwTkKDPirrKO5SNn41wgH1jQhsQd9Hn5aR8FV9rgSR415?=
 =?us-ascii?Q?IRtDiCF/6kzsVDSrDYjCGvFY1/+vvhCFshcxgdUaSAvJVKqyJcixLI0EOP8b?=
 =?us-ascii?Q?RJinECvbtKwAv1wzuNXqrKtjaHbYsL5MewbjKPbo0wwkmYD3CTuxrA0B6BzR?=
 =?us-ascii?Q?esuSCUBXJ569t5SSPIOQcPuvtABfmx24fSzlFqXe3iDO15NpPxGt4T0PIOj3?=
 =?us-ascii?Q?G/QJIm9iKlJW5V1cQ4VaRcey049nUx+POBMUDhOixqf7B9viK9iQdpBhUPCn?=
 =?us-ascii?Q?z/3n7oFbRnFVrf8MxhVa15usYUdEJTu7/cJZQ+TbZsVR5Jjv5/cPLJgrePjO?=
 =?us-ascii?Q?jwxZ/dW9ptaUCBZnDHjgYQf7OIQZ2Zs=3D?=
X-Exchange-RoutingPolicyChecked: SkxPNHeGDm0hQn2FolWwVDS6+Ri/NGbcneU+49MBi39lXS8BRoDVrpxN10WhhDkdoVYZl1nSN9FtyG7vAZy59e2El9dhioNGzbOBY2CwY/CAQ/TBi1+zvuHGNBkhqnGy4jM1HWxyTrYFtf+2GR7A32UvJvkTbsBd3+qyLLtZ5KttUlukBvKXx6FlCi1RPOuOdzrlMOWaS2rq0Iwnh6Z+2cCjUdsCYTB34S+V/Mq0TvjesFdbvMxoX5OvxNpOMLYAqW7q+qZKnn8yIhfQfj0RAjU3fbKPQ4sVH+UtaDqTgJyk+5FsCBv4eJr1RRbop7oKv7gpB4kDUGE4w9OaPEZzNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7460fd-c53a-4bd6-1a22-08df4a59d6c9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 18:36:22.9195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqxdrAMKGzNM06R96G8hdFMMtR0VPY2dG9i/U8AetBDHciDq7lSZK3g60m+2/V49sp7rEdEO/44LZhtDOP1YgdsSoRwlaqQy4a7XHrIx3dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6091
X-OriginatorOrg: intel.com

On Thu, Nov 05, 2026 at 08:02:26AM +0900, Anisa Su wrote:
> Endpoints can now carry a dynamic ram partition following the
> persistent memory partition. A DC partition is further described by
> two properties reported in its CDAT DSMAS entry: shareable and
> read-only.
> 
> Expand the decoder mode to accept 'dynamic_ram', 'dynamic_ram_shared',
> 'dynamic_ram_ro' and 'dynamic_ram_shared_ro'. cxl_dpa_set_part()
> selects the first dynamic ram partition whose properties match exactly.
> 
> DCD may be disabled during validation after the DC partition(s) were
> added to the DPA layout, so a decoder may only be assigned to a DC
> partition while DCD is enabled for its memdev. Add a helper,
> cxled_dcd_enabled(), to check cxl_dcd_supported().
> 
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 25 +++++++----
>  drivers/cxl/core/core.h                 | 23 ++++++++++-
>  drivers/cxl/core/hdm.c                  | 21 ++++++++--
>  drivers/cxl/core/port.c                 | 55 ++++++++++++++++++++++---
>  4 files changed, 105 insertions(+), 19 deletions(-)
> 

snip

> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 8a81be004d00..24fbb5718abc 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -6,6 +6,7 @@
>  
>  #include <cxl/mailbox.h>
>  #include <linux/rwsem.h>
> +#include <cxlmem.h>
>  
>  extern const struct device_type cxl_nvdimm_bridge_type;
>  extern const struct device_type cxl_nvdimm_type;
> @@ -18,6 +19,25 @@ enum cxl_detach_mode {
>  	DETACH_INVALIDATE,
>  };
>  
> +static inline struct cxl_memdev_state *
> +cxled_to_mds(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +
> +	return to_cxl_memdev_state(cxlmd->cxlds);
> +}
> +
> +/* Type-2 devices have no memdev state; nothing else leaves @cxlds NULL here */
> +static inline bool cxled_dcd_enabled(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
> +
> +	return mds && cxl_dcd_supported(mds);

Same as Jonathan here.  It is mds, not cxlds, that is NULL for a Type-2
device, so maybe:

  /* Type-2 devices have no memdev state, so @mds is NULL for them */


> +}
> +
> +const char *cxl_dc_mode_name(bool shareable, bool read_only);
> +int cxl_dc_mode_parse(const char *buf, bool *shareable, bool *read_only);

cxl_dc_mode_parse() is only called from mode_store() in port.c, here and
for the rest of the series. Can it be static in port.c, with no
core.h declaration?

snip to end

-- Alison

