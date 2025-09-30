Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E987123373D
	for <nvdimm@lists.linux.dev>; Tue, 30 Sep 2025 23:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759275218; cv=fail; b=jSRnPV70lqVS0wWSHuuyVPbP+uzgJEpbYpbT0UM/0/imqlgCydjjKsj4xQJR/ErvV1B9ryhYMLgKc+djEnf011oEanr1+3JYh8aL3pDV1/vjAaNDKs/VffuKOhzTojn0Z8KHVcSihQQQBVrUDEt6ZlZDWLBUUayZ3890ZmI9T04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759275218; c=relaxed/simple;
	bh=zyrvqpT8/cUvAV3gfXxA5O+opdRsUoIXBotPP1q0kv8=;
	h=Date:From:To:Subject:Message-ID:Content-Type:Content-Disposition:
	 MIME-Version; b=ibSTlSup6aifmSlXdpeWAn+rANNKG277OHUvuzLOZ3bBM8uGrT1WdeVclXL5G3QZHZIQW1oW6Mlj4UkyvrJCem2uvJdfb/8TO0hPtAxtlpyTtv6SWYiayQH80G3laU/kstmkEazSekYxVyf0OrCDn24+0WKLh2rTMSOWy+6uetM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ggfhBd5C; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ggfhBd5C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759275216; x=1790811216;
  h=date:from:to:subject:message-id:mime-version;
  bh=zyrvqpT8/cUvAV3gfXxA5O+opdRsUoIXBotPP1q0kv8=;
  b=ggfhBd5CHnvBSSIfkcF5HFJo5xakW5z25jxvMTxe4Q701+lAz4bNpGqQ
   TlSbjof6v2SUE+s+Alfg93IGV/gYalFliroQjxjLT8XzzK5fDZw01KAXN
   D4ArFNteT9EqTuLYZrl2iMVmJXMeEyU2HeyqsQ4hvktiJVHtwysmhvJyP
   khT+tcOOriZzmZvaOMp4opg/lfXKv9EOi9alESGd6vNPev6QfDGCVXAnC
   qbfzdV6oPTddUm6BZ5EY2B0CvGMONQbm4MsvU7Xn49aKzp/b8MRckbhJ1
   HmLDX6aFESHcwLMgWp/M4CfLW5h7yKw1fjWMLkzT4thZUM31K42aJwN6z
   g==;
X-CSE-ConnectionGUID: 0amMPJF3SX2gxT4hJzeSYw==
X-CSE-MsgGUID: ZjAlijYwTEWJTMWMCipIOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="65183027"
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="65183027"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 16:33:36 -0700
X-CSE-ConnectionGUID: vp8wRtUmSwmoPMbUzFFeEg==
X-CSE-MsgGUID: 2Q6MijPKTwCexPiMUf42gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="178240585"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 16:33:35 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 16:33:34 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 16:33:34 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 16:33:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kRmRxfAHIuiU9Vt4tjLWueewvvCddzPwtHDHe0y1TULv37AnPIXZRS7EBA05Ya8rSUvJ4VU/NcyDtwLGiCZe8+b6L9kNGMyWO2xcquqmmweAGhAba/aauUWRz1eCcHnOBUCPIzhgU1IgrAILUafst3/j5NWR9mBSurGrWAN4oGVO6reU/xL53sQTyZhAwERDKPBlJgW/Ilj2ilg0qidcgQNXSlFAxNwHQ/ARVeWDEq9ZmKy61C1UQbEQPYEF2AmF78OOx0HWYGSyeTJYtdfWCqUk7ScZCLNCzmpI6hahOZIQnHnoJMhbG9XUFg3h1pMDAx5IfrMnFC5Yqi2lWLxQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5etGnZkVqeWv+huVasRTnUoSR2MbaETzhNQoIsvZjY=;
 b=udr7Juu2mGL+WGOT7UYCpIzYlvdXx0jBmMi2J+peX3T49522LADfhy0QW7VzcGfQt8OiqMgR7mza4uqAxJz29Rgkr0ItBLr4Rf9ROKMmd3Yv9sHokh04Vsjm/Zwldnh92KjvdMosE8l2e4oLZYPHao8SG/HuNrP2jzSqDsiaTdq6XR+1mSQtHADfv2FQbe1X/VNRmUTVTsNZui3K3U/mM/UoaaQzIJeFSmFUVYHU6OicFtlCFJwyURqrYQifrlB/dT8HTEsHAotm4jqoZsVPIsAwRoSL9tkolKCD1ZztU4Wg9hMag67flLeFsgrT8JzkzPi4hgBoJMjSDCKsBTDEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by CY5PR11MB6341.namprd11.prod.outlook.com
 (2603:10b6:930:3e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 23:33:32 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::4df9:6ae0:ba12:2dde%8]) with mapi id 15.20.9160.008; Tue, 30 Sep 2025
 23:33:31 +0000
Date: Tue, 30 Sep 2025 16:33:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: [ANNOUNCE] ndctl v83
Message-ID: <aNxoyAx1uWdO8nbJ@aschofie-mobl2.lan>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SJ0PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::13) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|CY5PR11MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: c5503f51-ce91-4c90-b5b1-08de0079c42e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1I/LRH1d4hmOUAJh0B8VxGgTui/ApIcPHEWNR4bohbmnZ/ep4mic0yC2fx2H?=
 =?us-ascii?Q?oijA2TCux5QEOk6FUuPxgwshjcbuC8Mul4nj6jBspOZNMXgOKOxSqHPWJRWn?=
 =?us-ascii?Q?2J4bkiwgJHZyCkD22+M/Sf5seDOGKyR+EVEyl3moOkrnaRXw/qQBws+/e3wv?=
 =?us-ascii?Q?gB8cm84YLNXMDW0Pv967N28qkFz1+HEL1Bo3HNzU6WMgzGdZg/muXRi5bX/v?=
 =?us-ascii?Q?Ns/4X7ibsHUavT8dCNvYLZDAeykAjH44K/Z6Ybt5D/ULJfIfvdG6opZpL8YD?=
 =?us-ascii?Q?5xRoXNuqQSrw13b/6gnDXfaAywhE+HCg40P9cj4/fv2wFziE2KZ86ebvaiGb?=
 =?us-ascii?Q?bTVIZgTeHgWLomYFfq40XLda6ObuTt/+lsqnpQkUTvcuEaOsTXkNms70wroM?=
 =?us-ascii?Q?9aMAyi9dEvzDWj2xDHEyHALlJrtCD6iL2mDXVBo8QT624f+FTEVjsngUR4LA?=
 =?us-ascii?Q?tySgo70Zkv+yTguw3Wmp2jdUtJdmH8VUOqjJWiZuEaCk1LZesfTazgp8InO0?=
 =?us-ascii?Q?SqkqBkgb5oTszIecxvBmANleAYk6TBYqix+AaKqR+X8yQI71i3qzN7a2JkMu?=
 =?us-ascii?Q?2wWwVSUuFTe7A4UhtQp1/N42S5uVPz/rPmFItDsbneMpBrSgZjGHgLzDrFbu?=
 =?us-ascii?Q?dRjx01zzPOZVH+AxfPyFfYwaqvCivLgBwphpMA1sGHFqkTYh88T3zCsNCrbs?=
 =?us-ascii?Q?oIrgvXlBgNHtDLS3a2FpubNuJp8FbJ+1+k+bA7NL0O6V5nXuqQz2cOW+kBC9?=
 =?us-ascii?Q?TZRHyGfZObaGRhfeICe2+u9bjOE9jPryVCNC8qHqGSgm7QmsQqWq8r4MeKFb?=
 =?us-ascii?Q?YM/dEjzDmbtOYDRD+ipHuXlM9XW8Jhdrmr6B2/8T+VZsYe5wC0Igq5CB3/BV?=
 =?us-ascii?Q?iRXm0Qi8VriBAoi7iitPXavlN+wdt9bavvxxfeaxuDZ7H6IDoErpWDcqqN1M?=
 =?us-ascii?Q?kOr8wO/uoeQW2Esykd0pLlxcOqzrkWXDU8c3dJuZM533mk/QXf99C/CXmxD+?=
 =?us-ascii?Q?GG0D47h5I6xQ8GXTUYC5NYz5DcPZGimO0t3tObc2sd0CCK2B7UUkp52wNaag?=
 =?us-ascii?Q?ExQ3MeAc34IHwGwBEait+7pZwCN8fAkvqbmGgWyMCVwre3Kb9NhKb3Tof3VN?=
 =?us-ascii?Q?h97q+hXYqU02w7RUQblIp+YAsMaJKB7UBF7FFkGI8KH5PLU1CHgnKMAWHnYK?=
 =?us-ascii?Q?GSycEvK3+LPylfahy15Hsx4iiu1IJXH5VaIYQU+BFtMe8HgEMpiB4d7u3m2n?=
 =?us-ascii?Q?i6+uIm+JpG+uVrDnkDlg6S3Ffd7YDq1gygEdluXfPMEpHMrIEIn2rVw4Fbz8?=
 =?us-ascii?Q?tqMqfkoCxhb8dsG+Uy1fJ2w2yDmReaGsKI5qQFYeknkh+P4n/2/Dy60k+D65?=
 =?us-ascii?Q?plyxT92n3NwWn+UxyUHNUabJMMXLynOxWn/eq5TenkWlTx9ov66ErHZ6Y51W?=
 =?us-ascii?Q?OHmUJk9VQC6nUS9fZtW6p3LH7xQUcgiZ5f3Y+CYqBKdYxj/ojarG0w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ITSXflToZkJiHMn+x0aMd4iRfAXBbqsgVN4nzflNkgOkkaP/BEp9bpbZvETy?=
 =?us-ascii?Q?go2fIUYQubUxPIRLTx4+CeYfvALV8Avxi4Co5kJhorqjw9KH1bFDRC8qtSK9?=
 =?us-ascii?Q?8EcdTxsFTeZu8A8JN8SrjYAnxO0MWw+cnEq7vC8fnFtNku7C1NzrbtNbLjLS?=
 =?us-ascii?Q?iqRkRYWJfa9Y2ErbruEHmjWlstLfaaGS4kEoH+GUB8w9xcm8ccO1dQ+PhFc+?=
 =?us-ascii?Q?K1WZ+5QEJysXbTRW4ygWC6ChTXnd007oNVGKqrk0p25RwG7e627qDFV6QvN0?=
 =?us-ascii?Q?lcLg7F3XBWHI6Ct0PC1rs+5nkLxx5DthQ9JyNyNDLj5WfXGaVLXE1dDCjgAF?=
 =?us-ascii?Q?4/hzfrf4DstXaIB8y++zgtqpbUKUWNipG6yGZg/SPNGZwzzJt+EDE4x/aXJ1?=
 =?us-ascii?Q?+FMxItWDbxHQggHCGo1nSv0cj+Y4Gsyg6btqoo0pGu947qbVF4GKToVP5hyp?=
 =?us-ascii?Q?b0N4LkPv2O64LS7Vf2RgkJwZCT5E8vK/k0zzGTz5Z+EZq7D0zbzwNRCCjc4v?=
 =?us-ascii?Q?EUk0zw3ULE2BMO1kUtcWia11/2vOdPLWwbIIwLaI4O1KOSL0fMbuKS70Q2hh?=
 =?us-ascii?Q?5e/SxvwUpBWKR2cBdFEnMX5Gn6Hfy54bpg6+CbPJa+pHX6Np3MGp9Ni2cT/Z?=
 =?us-ascii?Q?+9WVRwmtqXg2cdI8EQGDhW7Ll2gELjrDaIAzCftP7PAMRjO0B0Sz2aJNVfh1?=
 =?us-ascii?Q?8XoLDXmSJ4zq5AtEbuWtPZH3EIYTtEx0NF2YLCxjq1UB7dRdrhN0GmXl3RAZ?=
 =?us-ascii?Q?djPgu4//USiEcS6O99fz2kLG8i+Akt8aPzERWe6rI+2xGixT/v3Um0UTLLRr?=
 =?us-ascii?Q?IFdVODZO+9u6p5p6AgCCstThnKMaQdAMC8zoGhw4DCVUXuEhKgg+UgcbBuRB?=
 =?us-ascii?Q?QrC5xiVjs4ecrzfRrqjO1wcwC+1MBWSHjRn/0Hmo0ljMQyMjas+3xkaDBjJT?=
 =?us-ascii?Q?33wb8kgyJhEeuAUiNMVIhz/hjv7zzUqZdaEb2oazeXkP9ynPI8ocYZPmbvvo?=
 =?us-ascii?Q?MtR8QPJZSpsK0pio2tkhKasWEFby4OUQiAvLWs+DxZv0aXPdmzaiE/o5iLZp?=
 =?us-ascii?Q?99nLAaMmZqsnix8A/SqmIt6elZCpPA2QCG2VjxLhv9vPYVffwLxHFcs5Muho?=
 =?us-ascii?Q?b6ld3yllEzOY9evOWHDTvRGpJv5H+llREcod1YpahMg2NjUUPapTEGVR+6ZA?=
 =?us-ascii?Q?ZbNswNerdeihT5oiUGtMDrgNHmEyEMMoDU6VDHXhnHkdcWSnicqeXluoyT7n?=
 =?us-ascii?Q?4+s0bwdWrVg+1lAEXO/HQ7znFuJon4jZGN2Iw5j3PLyDC+3BWfd9jZKhnWsT?=
 =?us-ascii?Q?PajrVngx+w6f7iAOs9dKNauW6Aq3kc2c/+F1rUrvdyRZAmxt9UyG6gbFwYmz?=
 =?us-ascii?Q?FZDDHXYdbQvWe1UlH8tL/j3HLqEZ6u95bvKWhwDGOn1jKW8e8DaHc04m0dRf?=
 =?us-ascii?Q?4S2fLT8i4Ksh57oOXDp19RFjqzn0nvsy8N0P3cyuaLkOqT5Ek+4pdTRgfta5?=
 =?us-ascii?Q?qqu6Hx1cWjFrz3vmxeR12GeLKEbcb8D4GzAxvOHcnBjS3VZ3LfVTfBORpQh+?=
 =?us-ascii?Q?kqi4+uKmvsGl7ps4aXt3l4/WBpdbb+Lli/Znw+Q5jbTzKD2ZrBsA5yTMyuEP?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5503f51-ce91-4c90-b5b1-08de0079c42e
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 23:33:31.7968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkucs7VIMVXdLAl1pOwv2Ws96K9G6Atz45zhGHrqBIG0QoaDysoqhrT2+ypNFTshPBDbdp193PmDVvFXV/kLs0t2DyR0PtLvGtNaZY6TYKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6341
X-OriginatorOrg: intel.com

A new NDCTL release is available[1].

This release incorporates functionality up through the 6.17 kernel.

It corrects the issue where libtracefs became a requirement to build
versions 80,81,82. Libtracefs is returned to optional status in v83.
Note that the '--media-errors' option to cxl-list, as well as the
monitor command, is not available when libtracefs is disabled.    

A shortlog is appended below.

[1]: https://github.com/pmem/ndctl/releases/tag/v83

Alison Schofield (2):
      test/cxl-poison.sh: test inject and clear poison by region offset
      cxl/list: remove libtracefs build dependency for --media-errors

Dan Williams (5):
      build: update meson feature deprecation warnings
      test/sub-section.sh: use built ndctl program in unit test
      test/dax.sh: adjust trace parsing of fault results
      README.md: update package requirements for the test environment
      test/meson.build: add fwctl dependency needed for cxl-features.sh

Dave Jiang (2):
      cxl: add helper function to verify port is in memdev hierarchy
      cxl: document 'cxl enable-port -m' behavior change

Marc Herbert (2):
      test/common: add double quotes to bash variables
      test/common: move err() function to top of file

Yi Zhang (2):
      ndctl: fix user visible spelling errors
      test/dm.sh: use dm.sh as script name in cleanup error message

