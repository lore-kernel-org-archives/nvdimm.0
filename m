Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792635666;
	b=eZaGwxvhulITVNhmMLAOO0xOQLStERClx5CKxaEnSn/3DC+VCDJGBK+KRbb+FcAsB4XN
	 WbNGQZ7xsQaAlEUNkyz2qBup3ipjYPnxy+IhxNwqq3dLdRyiqBZJcY4au5fPBnOWMqtUO
	 qH9gvfyEXPbWcaFZGw/UJNIzjfHGoBg+x/pHRFFf9/wwpxItHooVNJCW7eBhELcC+5o+Q
	 wPSK4l37HhPlaeEE2uz4dqadPiCsrXBoKp/DE+kts/9j6qK/eU4zXhf+mvMkcoQCSDbJv
	 ldII2XKDcwIwrQJEEQxDlsvcCzlIK8iwYipPmkAMkBoGZ3mBlO88Savuz7HBWfDIrxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635666;
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
	bh=6KvVW03NdgvJ3tftcuBaYuhQqfEGPvPchwdparfk9ho=;
	b=49NpomiU0swrao2Bf5TD0MN+kVz20qgCP5fyzvMMzjOzhs5WW7+Cqqvsjw6tWuDEuS9M
	 LJfRO9zGyjV/Gw7N6aMkSEpdW9QnVrDt8rfdm5gpiTD0Z4gyE4BLtXAzPaDMCM3PxGWsg
	 FhKVN7rbPd01YPGqEjjA68t9cGZAFPMku7+4zNre1RUJ83FfT0DkvE78UdXlDrY64aNcH
	 CljrLYYQlHjvbkDFHnDwnDqkslGm5/noZp2/s0HO1C88fa6IW9P8dOaZqAD5PVaa64yDc
	 MD31hiyJ0xkluf/eTthCtD6MjPLR2V5wSZLgA6iyR7b5yEzrIA9/fFPHLgzHaoK5a8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kKKaT9Qu;
	arc=fail smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27218606A319
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 02:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27218606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kKKaT9Qu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792635665; x=1824171665;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=w6YQRb9NKnUFh+YOX7LTJ/xXx8eroaYb3HR3oF9Eyrc=;
  b=kKKaT9Qu/T7YUxLprmYvb3OQx0/dBt8TjIE6u/m504gi+9teLTYAtFox
   ELAVzG3WsDh/uG53piG+d+wU89O8B2aHqe3okLhBqr+wymxb6bRQR/h2z
   S9a4VgFW2zcyr4UvNXdPULAO8lLHTBdYFjQu+C1UEl8R2shhHZjx1nEto
   4P4tlc9HD/9pisxGGL0y1SgljHVmXy7ZrLU3DNeRoFoM0dGR123c81/x+
   f/Dy1XF3I4zY8cv6OY8nt/39yGaIbSqMvA8v9XeJ/zbNC7HI5yWs+z+92
   IFhcQg3qYORH0uuw5L8u7DSz+IkjNezSjTVC5Bm1AEBDMVKJLSDQEqbRp
   w==;
X-CSE-ConnectionGUID: TxtUpXdcQMGVSFjv9k9m5A==
X-CSE-MsgGUID: Xs64c6MTRdGTKF4N1xU6lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1360991"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1360991"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:21:04 -0700
X-CSE-ConnectionGUID: QK2M+XkRSryPhIvNxT4phA==
X-CSE-MsgGUID: kWy4sZnqQVm9LccVmbvR+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3238265"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:21:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:20:48 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 19:20:48 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.28) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlILXBhmFJFNQgvha2q3YEMJEfZpv5ms4XuDRp2fpaxv0swz8Z3wqYY9xa07h1PULnhSdX4pE0T0Rb4qrXvIoE9jcp5m1WDB9RnkFgg5Mo0e8KRnm9ARsBl9TtfZMvTJsxoZ6COiYZ/kdyIba+Ufa8t3ZqpF2qyLXOj//sQIkAHhLXsTowAfHN8IjSq2XCSEvqoFMvewbKnHUAKbqrQjrMwYvfEqPj+2xcxmSjTffMtBISmEqlQWjpnf6mSZ1aaKAlIfQWNqKr0Iw/y0J1nu5NYGZ9PcxT6GHvECgoOAV1utygaf97jg2wqTh8ZFYl2/nzjDeygri35yI/DwMjTkbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KvVW03NdgvJ3tftcuBaYuhQqfEGPvPchwdparfk9ho=;
 b=PqvVFbW/e7hVuZNYYTSkq3M+7xxoT/ycD6Pg8lZ+D3rBmLLgVzOPgyH0cK/YyDgd/CnrUeQPKrYrsKCNLJbGC6uaRcqM/GCfzyQbwz2WH0fw1xkiIjKp6P0+GmtOPZHtXy/gdqmTUOPGS+sCiqWCoZN0/IAMO3D71WZNgNhhb8+tOSbbtpyeETafRBNMRV09SjzE83RWjuCacc6Ek3kpys8EFXtvz67ylm09Lf7WvyrvF+z6LWlo8JPtKtOxJ6dIjnoqxC6s1xLZbRbmvmqyqMetv2WoJRpAd4v8jsK4wb4/ofEL4Uxcxmvp8vdDHXD7yecnDfp2fdNyxtoNR3KkBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MN7PR11MB027855.namprd11.prod.outlook.com (2603:10b6:208:637::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 02:20:41 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:20:41 +0000
Date: Wed, 21 Oct 2026 19:20:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 3/6] daxctl: offline whole-device memory via atomic
 unplug when available
Message-ID: <atly9gd-Rsf-AoqB@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-4-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-4-gourry@gourry.net>
X-ClientProxiedBy: MW4PR04CA0352.namprd04.prod.outlook.com
 (2603:10b6:303:8a::27) To DS4PPF0BAC23327.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MN7PR11MB027855:EE_
X-MS-Office365-Filtering-Correlation-Id: 16762f79-c305-49d4-be82-08df2fe311e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|261021123027099003|4143699003|11063799006|10067099003|261009223027099003|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info: PE9d/LbJgv7AjMShhNTdZHx8A8MnE7LQ5XX/GAoIIGNqZVM4Q6Wd8sFkU/UnoisvVK5Ws+63dM0EXIyF8oZ4wHB/ZmxYC5fdKWx8+/QkN7KL6PqbRbx1uLq4Gi2E3ZOgKx08YDRDOqWnFHQrSCP9TttUQ5EwIKUm9z5lubWRQmz9esbipLIYCKD/bEMe4c6BYUPVoNTiL5NBo+KoeLG1wfjTuuXbEeJfOqAqSNS8L9eSCjCCCqFxQlKMabdhCZfFv5fRPn2DjLbRmfJQlvMeitmsgrBi0THgD9x8IW1aijHZXRPIGkhDL1FNJe3BSLqbwP2tmjZoK4uQTw9hygG2xp++cQJT0894P73ZFlGmFZ1z6zB5ZNLhDr110tmnJ26bVkqYcH3KWYkj2nAhXGndwZUU7wNlmtsHTAhZa+F+04WiqIs6iIusJFX4fpgugaOURMNqaQyCw908M59azvK/v154hLwVrR/g2GFwMlwG2R2peHrafwsr3rzqc9HWWUNLTt/EPF0Fgrkez8yxmzxoaJbqYVbaETgUqKhXuvM8qCnrk5ksGMvsCS4hBDFhttF0cCHr+aHJANLjwStEDIgpILs2TYlgDIlaLin+bmImnbf9lgELZR8ZNoSY6LT1gHkITn5U3cEvgcr4Iw2iYoPUeJzzXs/7t9KrnQ6hfREkpvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(261021123027099003)(4143699003)(11063799006)(10067099003)(261009223027099003)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lGFhtCoxeoTgZjRIV88xpqjRgUNHVSsCWk+Ez/9n1SZOKRj5cRx+3JvGoKvg?=
 =?us-ascii?Q?lwrOzsMRI1ldt+1KRpe5e8E5SadE9EAc50CYeOrPLYlI9QfMo4OyegFyQHiT?=
 =?us-ascii?Q?WuUibijOnQd5bOXxkHaysTR5Ga5nDaC6n4jaz2cUGKzuPalGA2lNynp8Vux/?=
 =?us-ascii?Q?M0XjQmkjyOo0QHZkeg6rr1+R9b3mxB4i6n80eHoBfuz3+bDy3YiDUZX6TFzS?=
 =?us-ascii?Q?72Hr6QPhDOuXNIykg9bC/0I2qYM3VpaU8vdCfcaI4SRldlVQFUjFXaWXXsVF?=
 =?us-ascii?Q?rhA+lv6KQTHmiFtrC3udx4866BAsLpbJBXhW64tlcPhuFZzO5MxgOscpRLfy?=
 =?us-ascii?Q?QwhV3EFmRr3tvIhArsccK4N0v7wqAuQNkKsPqQVd2ojJ6joJjDbS5/OnIpPX?=
 =?us-ascii?Q?fsuPfbMuQnlHWgZ4MjmkX/H8LtnZo6h/RDpi3DbhU9ZlFAKH/JEOXPgtdNoL?=
 =?us-ascii?Q?d+JhhGpEGi8T0gJJ5fQDHyplI/hKaw4mSLCN/xQEL8vgXyI6ggYr3XZZu8jZ?=
 =?us-ascii?Q?LmMD5nNXNDC7WZe6PtYMu3yW3b+3KeOoxTB8kGEQAgEl4UER+2CF6Ih+d7Lz?=
 =?us-ascii?Q?d5lfmlVGlodJvF+jEHE83KT+jy0c+jcS2bVpCGK0j0Hqh+kJO5i50XVksHbB?=
 =?us-ascii?Q?KUfbv5uiIMPiK/Ev2uum/p/F18tRFVKEXblC2pAgppNTHdT+fWwZwxmYwzAu?=
 =?us-ascii?Q?6ANVnvRAaxPKZQHnsxJ8J4acnrLd4IGjCrDFN2SHAH04RWQqsm7v/gwFVGsU?=
 =?us-ascii?Q?JWcbPOrVfHqXbRhemzqnbU3f3EgfQ8kO83K5b6uwHHBsBcGxSmIo+akiIO0S?=
 =?us-ascii?Q?674m8RqFBzbz1Nfg9g9HgTft+tQI9jOdN9JXnbeh7qqRNIRZ78mFKeVhVMf4?=
 =?us-ascii?Q?IOd8i4DFA/lOi5CVQAW6Mves9MdqmCDSvV6yEjR/eusLvTZ2kCdqTw9cemoD?=
 =?us-ascii?Q?CMr8VKOhXJGpttFcmEh8xXWZA0vfmjP3udV4oAekxjp/LsTQVap0FdYLjq93?=
 =?us-ascii?Q?iRnndcXDpDL39Y8OtCvYBCd1Gr8lBWd+e+ugYuOdt/NOiG4XhWMsrn0ZIsmK?=
 =?us-ascii?Q?q2J8ZLLlNipaw85jPTuHNK7Y6AK2k9hRscq0TuUFXOuEKhpFk7BgVYGCZttZ?=
 =?us-ascii?Q?m2pfJ31bU2iLJuWi7mTRDpOjIb2l3Dd5w3DcYKTnagiMFEm3toV3FkUremfO?=
 =?us-ascii?Q?9zXY1qUP7t/evTGj5mWTxG63ZbzO9tM2HTd9gaUKBqgR1Cj8K2DcbbOTSXWS?=
 =?us-ascii?Q?3e3w0Rp+ecm6cN/BXy0I3ijXTy0W0mTZNZXstUYcHXyy0zduUCgjFPFuKZ15?=
 =?us-ascii?Q?IL/lZkmdhOB9bWQj8rn50L1RDs525byTOJt7pAwxFOYwTqHbqNtepoBOT3fp?=
 =?us-ascii?Q?yxrJWZguzXD7rg3RbQpEjjgVOte0sMvgIyTxYmx/ajet9Yza5UJsNPLrXiiQ?=
 =?us-ascii?Q?E19w7xGZlDWzXoNDn+HSMKXQtkjahzAea2A/jJ2jO+3qbhKuDH8pDOaEJDvT?=
 =?us-ascii?Q?5A/vjHTyEkjKNOYHc5ui+Knw+rZxm3hdfdX9CXV6j63chHJFTXGLHQ3Cdwm5?=
 =?us-ascii?Q?nbn/xFDsgZYVZKwDl7wtPIvb++rF2vBv9+zwiJYkA1Wux2owBR7XAiJbZ3o4?=
 =?us-ascii?Q?uyUAkxjRSUKpbBWoVYGfyOECy2Gf2fU8fQvSDcV3JqQZV6UppeEZWJkFaHBK?=
 =?us-ascii?Q?YH41nya+gsSgTIlxkgojwv2qlRt6a1IY8AtU9p/s1qcakt2C4lrhY2EnCN3a?=
 =?us-ascii?Q?rgPvZRhZIjvuEaNNbdCM5nVzebTEESA=3D?=
X-Exchange-RoutingPolicyChecked: v6bcr/mUY1HU+pVC8g3ubxo6GZLTg4ScWoZ1bzhP1Q/NXubAoG76hwpII7vJZ779BWYaJq6HSRjmQLbS01ncJ4oOnF+PElui2m1MI87IzpraLQZRVsr2H8hzKX3tq84y6PCsRR2gWjQXQN+vwg/3Lzv24fJkI7a2i4EvDeHPdfFHgu+PZSViWx0R1FLshua1QpruNQICjFkGqWfhW6Pl1TwyaUHpi2T8C5vvE6deUmwWd3xGnocVC4DR0bkO58GLjOXoLz+VWENpAIMKs0C0clM6n7Bw903OHv81ur/vAxdae0RA8Ct5O+FINVfJCWH8HmUR63QRPrbICCgiKO3Idg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 16762f79-c305-49d4-be82-08df2fe311e7
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 02:20:41.5892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLBmyhvkyEr6V5IcRZ4ahrmyCCSCZ6ayeWyfVulGEu/+b/7DDlAqMLJZo7Ru/B4rHF+fRzT0xyUFsFcOsRucQGcbtBk5x1nqH76laRRqGSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR11MB027855
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:45PM -0400, Gregory Price (Meta) wrote:
> From: Gregory Price <gourry@gourry.net>
> 
> When the kernel provides daxX.Y/state, offline by writing 'unplugged'.
> The kernel offlines and removes the whole device atomically, so no
> agent can online blocks before a later unbind. On failure the device
> is left unchanged.
> 
> The memory blocks are removed rather than left offline, including
> when they are all offline already; 'daxctl online-memory' restores
> them. If they are all offline and the unplug fails (e.g. no memory
> hotremove support), this remains a no-op.
> 
> Unplugging a node's last memory removes its sysfs directory, so treat
> a missing node directory as zero blocks when the device is unplugged.
> 'daxctl list' likewise omits 'movable' for a device with no blocks.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  daxctl/device.c        | 51 +++++++++++++++++++++++++++++++++++++++---
>  daxctl/json.c          |  6 ++++-
>  daxctl/lib/libdaxctl.c | 12 ++++++++--
>  3 files changed, 63 insertions(+), 6 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index fd84799..99c0d96 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -694,7 +694,8 @@ static int dev_offline_memory(struct daxctl_dev *dev)
>  {
>  	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
>  	const char *devname = daxctl_dev_get_devname(dev);
> -	int num_sections, num_on, num_off, rc;
> +	int num_sections, num_on, num_off, rc, unplug;
> +	enum daxctl_kmem_state state;
>  
>  	if (!mem) {
>  		fprintf(stderr, "%s: failed to get the memory object\n",
> @@ -717,17 +718,61 @@ static int dev_offline_memory(struct daxctl_dev *dev)
>  		return num_on;
>  	}
>  
> +	/*
> +	 * Unplug atomically where supported, even if already offline, so
> +	 * no agent can online blocks before a later unbind.
> +	 */
> +	state = daxctl_dev_get_kmem_state(dev);
> +	unplug = state != DAXCTL_KMEM_UNKNOWN && state != DAXCTL_KMEM_UNPLUGGED;
> +

Hi Greg,

I see you called this out in the cover letter, and that the kernel is
deliberately combining offlining and removing memory to avoid the race
before unbind.

But, this does change the behavior of the command "daxctl offline-memory".
Previously it left memory blocks present but offline and now it removes
them entirely.

Should offline-memory keep its existing behavior of leaving memory blocks
offline, and use atomic unplug only when reconfiguring the device?



>  	num_off = num_sections - num_on;
> -	if (num_off == num_sections) {
> +	if (num_off == num_sections && !unplug) {
>  		fprintf(stderr, "%s: all memory sections (%d) already offline\n",
>  			devname, num_off);
>  		return 1;
>  	}
> -	if (num_off)
> +	if (num_off && num_on)
>  		fprintf(stderr, "%s: %d memory section%s already offline\n",
>  			devname, num_off,
>  			num_off == 1 ? "" : "s");
>  
> +	if (unplug) {
> +		rc = daxctl_dev_set_kmem_state(dev, DAXCTL_KMEM_UNPLUGGED);
> +		if (rc < 0 && num_on == 0) {
> +			/* already offline, unplug is best effort */

When num_on == 0, another agent could online a block between the earlier
check and the unplug and that memory would then be removed.

I see this noted in the commit message. Is that worth documenting for
users?


-- Alison

