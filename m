Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6328921480B
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584763; cv=fail; b=hIiTyi2tiot1JkHg6gGOWMOzpyUADx818W+MoNIA59FlSMcPod2ZxiDAR0q5dbC2Rt6r/taKCkSTUaxqSgsyIz7jPKF9zNg+ChxGsZnQalDQjANju8olpz6ec07h9szQZjTR0GGqLAC1M23qxIJn2uEbGt1dR32Sd1ZmFVglUdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584763; c=relaxed/simple;
	bh=IXXz9ma+sLFTS3/AZjlqAxGNvG3+Lzvfiga4mSetDHA=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=MkfBTRxh0esnOFnCJwvu52blDE8B/y60j2ulKeWdIxSnwmWKwHRY2+Xs3w7WAUzzYYqu9uONgq67adRYgdW/3/zzGT/wRHFLYu00BEd2SYD46f9u6WMyOOUkpKfyyXjfjG1LUyhTiGy3MzdJr0RVRdj4NUXEkZvu9PlUsNu7OD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKLDeBzQ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKLDeBzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584761; x=1776120761;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=IXXz9ma+sLFTS3/AZjlqAxGNvG3+Lzvfiga4mSetDHA=;
  b=jKLDeBzQGkTI0CaJOjmqA62Tu/PyBWWc3womVD00IaePqSvGElVyZ9sT
   z81xqR3JcLY0m42OScteDT/eaXdYoNIpozB+Glj9TCRQ5hD7tgc0ii9wB
   xDrsvA6TTBfKg8BD1ox6eS8tPoXAz4aqvb4lo536dLD++mFjLXGcVzLXk
   Z4gwCCHDwQJG4UBJ6G2GKRsVNQE4pU7XLZwMacCq7WnkwW/EDSlR4fUWB
   6KKVAGaaVBb+sIZ4UU8PTK+IafL08PMpajfOCvt4P3UmUeFWS8j0RZpYF
   mfxZjA2LWK8qYp8ho6zsh3EUSBkRWa1tLH82ydEUocHZXrRYRvZVojKNA
   A==;
X-CSE-ConnectionGUID: FaiC1Pf2QJSACkJ/gEHAdA==
X-CSE-MsgGUID: 1gCMIjLVT6Ojr36ThUKWMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431156"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431156"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:40 -0700
X-CSE-ConnectionGUID: 6K8XBdPBTJGRyzlEGkvZdw==
X-CSE-MsgGUID: VVrMQQrFTtCTYCrUv63sNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405598"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZHfLNlsBrDQPI99YYkPR6EF/BW6R/qn8jV9Y0WDw8rHVxoiyb3mRc57WJmvnEcMeiZ3ltIP8IhWmdzwC/mOMBm0AYBBo/yo3qbfR/vBO6qLG4wiIlscfN3MbvNsM2WVgonGGhZQo0mUe41iUHTSYPOOBnsOgM/OBifeLiZHs00R/vHL8FxBjlVd5/MM6exWWubjU5VdcvzV4p0995VIlylz8QIV0rwswHFs6ujFHnMDxRoFPZI/BOIqNwCPxp46LEF8tj+/hQgLcAPJw9WaXgSMs2EZMiNfr0wOanReFYclgCjO6s54K/9lvgmrWg4k8dV7+n0I0cdrbGYUC6F+4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZl4Vlki6bfQx7xxAH7vGT4mRBwehSOgPocHtpdgXgU=;
 b=uRYjfek9H6jRh+sSiyPf3TgiTiwYWU3oWutDpR+ivUSC4VyV18l31mB8qnNTCGwDQpQGM5BMKidLWJEpzNM8Op7Fd0F5Bu8dBNs5rAhgVths3swEPoLklycPn/Rp98lw0XBL7dRdN8+VkmzaBp7HdBgFxrc/SwfNVib1ETBpWgmPt7j6PdAB1GdYxFy6dUYnz1gG6qGJeBUh9Lt0U/vyf1VY3tmDOM4lVqtIbneJYgoF2qwHONT5V4sTTJ6R4g8WlYqu+0AgTN6cHetT5j2jV2caDBzAKsEMmwvE7BLdTbyFVdwkudZ7ytKTjjhQSTeECykyjNeBR67zxuUerROzUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:37 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:37 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:59 -0500
Subject: [ndctl PATCH v5 2/5] cxl/region: Add cxl-cli support for dynamic
 RAM A
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-region2-v5-2-fbd753a2e0e8@intel.com>
References: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
In-Reply-To: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584788; l=4916;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=IXXz9ma+sLFTS3/AZjlqAxGNvG3+Lzvfiga4mSetDHA=;
 b=g2oC7F7fvdFc4wtEIH1VSXIhOwdbScPQp9SZhHuzNI0jECqA7L1z9pXG1Gy3QGaihpFHAbeZf
 vs5exITZQBFBhu2TMHU2g8Ha4lklKbvqvSHsmzxId0jFfoTwe3pvnUy
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW2PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:302:1::29) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 16b0440d-16c7-4fb3-23c8-08dd7adde2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXptenVLaXZwaWgzbmRrTGF0aVlGQ1NvZm1LV1dsTG9Kd0NkSyt3YXVqU3Vi?=
 =?utf-8?B?cWpQUjJRV2sxSUZ4ckUrZFdvODFhMDIxbWJuMjlPYjBIdkJGenNvM2toYm54?=
 =?utf-8?B?WVBWa0ZXM0hPMkRQZkVVeFgxVDhiSHd1VTlETTFqTDJRU2pjd1F2TEQ0eFQz?=
 =?utf-8?B?ZnNiQlcreWFESTVqMVp1dFpOQ01LMXFWLzU1d3JWU0FydkdoSUFtSmxKaXlw?=
 =?utf-8?B?dUtBb2ViYVlIZkZyOW85Y3BVOXVBVEVjRXZUNVhVMWcvWllCclE3TUxBWmVQ?=
 =?utf-8?B?Nmk2L2hSNlYxeUtmR3VsYmlObDVMeVpGVmw3NFlxT3ZFRlhaRGdsbjRDbWx1?=
 =?utf-8?B?N0t0VjZZR29Db1FYVjROR2liT0hKdktVM1N2TU5nTmZiNk4rTUVZN1h2V0JV?=
 =?utf-8?B?MWtzZ1RBNTA4Z2hOa3Y1U085bW1aTGtRK3VuOXJuQWd2Y2lpY3ZHcVkrcHFE?=
 =?utf-8?B?ckN3SzZMR0s0K1N5Qmw0bDFsS1RmZ09KbDlYcUpqWjBkNkNkVjBRaUVkTGZ0?=
 =?utf-8?B?LzUydU5BUlNsYzE1U3g5TVl6aVdRSjJQQ2FuVG5LcHpuU3RLcThSNitROTY2?=
 =?utf-8?B?aXBnQ1JaTzkzNnQ0Z2JCc1ZQVDErQTJwWnQ3VWJRQnJ2MTB3dVAvK2VpTi83?=
 =?utf-8?B?MnRBMEp1cDBaTTJxTmZRUjkxdy9UazBiSC9DNHpHZmUzRE8wK2JlMkRhMGtC?=
 =?utf-8?B?ajlzMHZUdWRaOUwxU0xIbDFPTFhjKytvTFk5MmtUQ0VOakxma0F4emR0MWx4?=
 =?utf-8?B?NzZQZzVNMnBGRnpvNnRTUCt1SmMvMXpBeGs1ek91VEh3T2h0SjduVWt1cmdE?=
 =?utf-8?B?RkU2MFJVN0VIekVONTR5cDI2ZDZFN3Qyb0szZXBjb25LLzJXTXh1YWRVTlVL?=
 =?utf-8?B?UHdIUHo2ZTJlYVZxeWhPandxSTFOR0tCVHVZa3RXdEFldGFlKy9YV2pua0NZ?=
 =?utf-8?B?SnRQWDZLOGIraW5ZbHJyRkxyci9PR01XYzB0cWdsWklSSExsOUQwajJiaXZt?=
 =?utf-8?B?WG9kWjZINGhVa3pmNG15USs4ZXVWOUFqNlIxNXVnR0JVbjhvRm9UcVIrRVBX?=
 =?utf-8?B?bzdCQ2JsenY5bDVPaFMxVVR0S040VWo4VnFMQVlXY3pCaFh2dnN0ZHdWUjBX?=
 =?utf-8?B?YWMvT0syZy91VWhoWHNRU0FqUERZeklSbkxxNEp4cXVYK0VOZ2Z5TXVRRnl2?=
 =?utf-8?B?OE9rTVpWclRnajFIU3V0eXM1S0szRXBrNzV1S2lxNVU3Vy9zdVA4SmRSQ21v?=
 =?utf-8?B?dkdkb0lHcVZEc2ZBbnJLN1VxWTUwVGxOU29PakhEMy85ZE9MamNISjBHZE1O?=
 =?utf-8?B?WFFqRlJVd2R2eHhHcGF2QkhRVEFialN2aTdsMUJQQ3hyeTlkdzN5aTJKUkRH?=
 =?utf-8?B?SnhEWUNUL0I2eE9aQjFydjF5SG9TY3c3d1VuYzNMa2MrZE5TSmprVlJtZ2Iv?=
 =?utf-8?B?YUtwamxNOWNmYmwxandUVGhUSWttMjZ3R1cwb3ZuTjI0MElzdXBNMStBMWIy?=
 =?utf-8?B?a2JRbStpZUo4MXZZV0FHdnFqYjlvbHBzRXFMMXBIOXdWLytSN2laNmlxUVBZ?=
 =?utf-8?B?Uk92ZUVlbWhTQ3JaazhXby9kK0tBK1ZpRktCeWFQdkYwTyt6SXNLUjgzQVRN?=
 =?utf-8?B?NVk5TFVRYktQZ25PQTNYWnRLZldmd1VOS0p0TGVlZEFPdjh5TFBDV2lkWFh0?=
 =?utf-8?B?U3NTeXZrR0dWby9Xei9jc0E4SXF1TFFjUzNjd3QwUTBPdnVLL2hEZldsOS81?=
 =?utf-8?B?TFdFRlBNTEsyZHNKTDlFNUdmdFZwTFJWY1F5V0E2WVN0ZThyMXRMSXFpSlhS?=
 =?utf-8?B?ZmpEYXNFNjlzM3AyMDVlZjU3MElJU1pRQkFQVHdpVVVJamNlSDRuTG50cWNH?=
 =?utf-8?B?VjFYaS9Jdmd3QXRVcnUvOWxKYkZqRkREQ0UvK0M3OERjSjhwRk5IOHowUmo2?=
 =?utf-8?Q?lt5+f95tNFU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0pGMHhqZFV2aGgrdTlrT2Z1RmIwUEh2OVg3VW1Obm05MkQ3L0NmZFYyL2pp?=
 =?utf-8?B?Wkh0ZVA3Ti9FeVZETy8xT0VUVWFYYjdnd0puSExFSTZpTDFJYzBjZmFtSmFW?=
 =?utf-8?B?dXVYVGdtbWphKzFLeW5jdGxiTFBxWFRHdXFBc0MzdmRaRm1idndTNUJ6TERv?=
 =?utf-8?B?bDV3dEtPYjRuRERKaC9RbVcrZjFkTGZTVFR6OEhnOU9jb1Y5RWQ0dlZYTGZ6?=
 =?utf-8?B?cFFuUTZiWWxOZ2lZS2w0OUtFbXVIcmhVSVBIOVZMcnJqVnpncXZnZU5qYXVj?=
 =?utf-8?B?amZ3dVI3RE9nSmpFbGtGN3N1cDlBZkJvSlRyeDNKMW9qaHFFVGNGRjVNVzdH?=
 =?utf-8?B?V0QxUjR5VXplekNhWDdMTGsvUnphYkxEQ216enhKUTNDMU93UEVtdExvbG9Q?=
 =?utf-8?B?Wk1BWjFPekRINWJZVUd4QTJuWmZTU1lHa0lBc3ptRlFxYVd0ZWR3N1NTakY1?=
 =?utf-8?B?ZVlNazJzTWJaSXN3MFgyczU0MmZvb0N6TGlZSThsblR3MEEzbW96N2E0M3Z2?=
 =?utf-8?B?UWpJYjQzN3F0ZE9hZTZhUEZLakQ3Z2VLVU9CNUNhWlhab3B5OFZ3ejVWUitx?=
 =?utf-8?B?eGo0QWVEb2NtYnhmZlFzbUNnY1JwYnVHdS9iVE45RGxHVEFXT1FWcXJLNVJk?=
 =?utf-8?B?eDV6Z1luTUJKMEFJZVJtMjVlL3RLTS9vVm0xRk8yZ2ZGS2tGZUhHanZwbno2?=
 =?utf-8?B?b1VYTEFHZWR2N1FWRjdVVCtpV2Z3WjJ3bERCZXd6aVExSGVhZ21YQUVjYzI3?=
 =?utf-8?B?Mzh3b2NvL29FVHoyZitRQ0svY2ZYbzc1elBZNy9CaDZEY3V0bDcrcmJ0YXFX?=
 =?utf-8?B?RGQ0eGdrVlBGSCttMTFjWjFkWkk5RHJjNzVYRmtOMTFyOGZFdjNCVkRNck4z?=
 =?utf-8?B?WjZkNTRKUnRnZ2QvSVhUQ2ZsbXBvam1XSlQ4T2R1WVFlclIwSXQwbnZRVFBT?=
 =?utf-8?B?QjZacSthSllNS1FoWmtyL1V1cGk2SzVjRDlITGJsUCtaZitjSHFEcnNqY0Rz?=
 =?utf-8?B?ekpEcHRWcEFaTitQY1h0RVdwQUFQdGc4N3NiQktSZE1EVUJzQ3NTWWY3cUp0?=
 =?utf-8?B?VVRJeFo0L1BsOEpxdkJudGlSdmc4TTVEMzJyeWNjczNsaUV1MEtWN0RwZjYr?=
 =?utf-8?B?U1FxQ0FwRlp5RTI5WW1IMmNYS3E2azdUTUtHV1NhZUloVEpkdGY4ZUtSKzRO?=
 =?utf-8?B?cTN4dFhvSWZZZ1IydHVTMVNEZEY3a2dVLzkyanBGRjhPTEFsWUV2aXVsWVZG?=
 =?utf-8?B?Zm1nYS9ZbEFCbDg2WFZyZVJTODdjdS9PeUttUzhVbUtqdVpCQzFUNmxJemI1?=
 =?utf-8?B?UkJybUE5VzFLRDkxb290SVIxMk4wVnRnMmtzcE54ZnhENloxaVpEWVlsVzJV?=
 =?utf-8?B?dmlLTkp5Y1V3bFUvU3haZVZMUVB2Z1h2b2pFWkdQU29wODFrb0Y0QkwxQnNK?=
 =?utf-8?B?QXZiUTZOQ04wYnUxSVVSOU11RzJURktiVzZpb1dxSG5TdU5xdjZMT3JzZ0VY?=
 =?utf-8?B?VFRSR1hsRVhnc3Z4S0FnQTRDSGhUaHRJbm1SS2xkV2VGWlk2dUM0NThqUFVy?=
 =?utf-8?B?bnBvdEVXdU1EUS9WUDAwVklpNDROUjUwUXVyTVNRMmZSaXdrREJwVEp3STd1?=
 =?utf-8?B?dGFXbE5sR2JYZXFCY3VuR3hGb3Joamh2YzA2N1VpNlVzNTZDSTZWbDJlK0du?=
 =?utf-8?B?dEtpMlVBOVR3L3grS2NZS2VEb1BQdG5PdHp1b01La09KU2RGYzhQUXhibG1r?=
 =?utf-8?B?VXN3RC9jRkp2c3hDTWhMZ2dOVWlRQ1lXQ2RnVnpydWVvWTR1dTRWdlltZDZB?=
 =?utf-8?B?Y0VPNEFXYnlzb09Pc2R2NkNKZHFVNEJUR3MwWGJEb0xPSDFDaXRmTzVLMW9U?=
 =?utf-8?B?YnFBOW02K2pxYVhDZGFxZXZJRU1td0dSWlBZRUVUWWNrdmlucitiTXpCMzhE?=
 =?utf-8?B?d3JBcjFOVExiOG1jMERDRGFkbEJBU3JzSlVhUUkyM3B2OWJSUkpTeGhxcDNi?=
 =?utf-8?B?WWVIN2x3dy8wWko4cDNpY2lHN0RGOGphMDRGNXZYZGkxVHJBcERoYWlUYmpn?=
 =?utf-8?B?dmU0TGdlSHVZWTRocStyRHNCSmYyQVNrb3NYeGFJMVJqVGgwOXYvSjRYVVBL?=
 =?utf-8?Q?Fqk7Sgih0wnQLceUMqFE9o/1F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b0440d-16c7-4fb3-23c8-08dd7adde2e3
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:37.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lF+VGSoNPb53R05D+8uAi1XrF01BKW8bE4CyaczJ+PrszailyDwWvcfFnUtntgrGdQDC7gw5kFzDaCSNlJZsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

A singular Dynamic RAM partition is exposed via the kernel.

Use this partition in cxl-cli.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: New patch for decoder_ram_a]
---
 cxl/json.c   | 20 ++++++++++++++++++++
 cxl/memdev.c |  4 +++-
 cxl/region.c | 27 ++++++++++++++++++++++++---
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index e65bd803b706..79b2b527f740 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -800,6 +800,20 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		}
 	}
 
+	size = cxl_memdev_get_dynamic_ram_a_size(memdev);
+	if (size) {
+		jobj = util_json_object_size(size, flags);
+		if (jobj)
+			json_object_object_add(jdev, "dynamic_ram_a_size", jobj);
+
+		qos_class = cxl_memdev_get_dynamic_ram_a_qos_class(memdev);
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdev, "dynamic_ram_a_qos_class", jobj);
+		}
+	}
+
 	if (flags & UTIL_JSON_HEALTH) {
 		jobj = util_cxl_memdev_health_to_json(memdev, flags);
 		if (jobj)
@@ -1059,6 +1073,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 				json_object_object_add(
 					jdecoder, "volatile_capable", jobj);
 		}
+		if (cxl_decoder_is_dynamic_ram_a_capable(decoder)) {
+			jobj = json_object_new_boolean(true);
+			if (jobj)
+				json_object_object_add(
+					jdecoder, "dynamic_ram_a_capable", jobj);
+		}
 	}
 
 	if (cxl_port_is_root(port) &&
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d1578d03..bdcb008f1d73 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -269,8 +269,10 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
 
 	if (mode == CXL_DECODER_MODE_RAM)
 		avail_dpa = cxl_memdev_get_ram_size(memdev);
-	else
+	else if (mode == CXL_DECODER_MODE_PMEM)
 		avail_dpa = cxl_memdev_get_pmem_size(memdev);
+	else
+		avail_dpa = cxl_memdev_get_dynamic_ram_a_size(memdev);
 
 	cxl_decoder_foreach(port, decoder) {
 		size = cxl_decoder_get_dpa_size(decoder);
diff --git a/cxl/region.c b/cxl/region.c
index 207cf2d00314..824274e25ed8 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -303,7 +303,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 
 	if (param.type) {
 		p->mode = cxl_decoder_mode_from_ident(param.type);
-		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
+		if ((p->mode == CXL_DECODER_MODE_RAM ||
+		     p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) && param.uuid) {
 			log_err(&rl,
 				"can't set UUID for ram / volatile regions");
 			goto err;
@@ -417,6 +418,9 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		case CXL_DECODER_MODE_PMEM:
 			size = cxl_memdev_get_pmem_size(memdev);
 			break;
+		case CXL_DECODER_MODE_DYNAMIC_RAM_A:
+			size = cxl_memdev_get_dynamic_ram_a_size(memdev);
+			break;
 		default:
 			/* Shouldn't ever get here */ ;
 		}
@@ -448,8 +452,10 @@ static int create_region_validate_qos_class(struct parsed_params *p)
 
 		if (p->mode == CXL_DECODER_MODE_RAM)
 			qos_class = cxl_memdev_get_ram_qos_class(memdev);
-		else
+		else if (p->mode == CXL_DECODER_MODE_PMEM)
 			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+		else
+			qos_class = cxl_memdev_get_dynamic_ram_a_qos_class(memdev);
 
 		/* No qos_class entries. Possibly no kernel support */
 		if (qos_class == CXL_QOS_CLASS_NONE)
@@ -488,6 +494,12 @@ static int validate_decoder(struct cxl_decoder *decoder,
 			return -EINVAL;
 		}
 		break;
+	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
+		if (!cxl_decoder_is_dynamic_ram_a_capable(decoder)) {
+			log_err(&rl, "%s is not dynamic_ram_a capable\n", devname);
+			return -EINVAL;
+		}
+		break;
 	default:
 		log_err(&rl, "unknown type: %s\n", param.type);
 		return -EINVAL;
@@ -509,9 +521,11 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 		return;
 
 	/*
-	 * default to pmem if both types are set, otherwise the single
+	 * default to pmem if all types are set, otherwise the single
 	 * capability dominates.
 	 */
+	if (cxl_decoder_is_dynamic_ram_a_capable(p->root_decoder))
+		p->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
 	if (cxl_decoder_is_volatile_capable(p->root_decoder))
 		p->mode = CXL_DECODER_MODE_RAM;
 	if (cxl_decoder_is_pmem_capable(p->root_decoder))
@@ -699,6 +713,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 				param.root_decoder);
 			return -ENXIO;
 		}
+	} else if (p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
+		region = cxl_decoder_create_dynamic_ram_a_region(p->root_decoder);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
 	} else {
 		log_err(&rl, "region type '%s' is not supported\n",
 			param.type);

-- 
2.49.0

