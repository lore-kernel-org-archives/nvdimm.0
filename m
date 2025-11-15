Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540FB221269
	for <nvdimm@lists.linux.dev>; Sat, 15 Nov 2025 02:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763175256; cv=fail; b=FzA0K9t42Ig0bgBaYE8zNBerMGnzajKJVGgxmPSqvUI5d7+R6hftP2L+iF2yje/ici2HSz4KHaz82H8ZsbUcvkjvSSJ4fUM6pb9wODI4Am9JlRdfuWShI5wia/F6iEKNZ4conoqp7J6R1dIdhw8kTZ5GhhL1eLPIe5Om/vVeWfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763175256; c=relaxed/simple;
	bh=68kCnZXW4wUOPihlRkLhE3XY9iJfny2CtYwecW7RfTM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t+Y5FXNcske9Q4QbWbpuLWER0GaHj33SntNZYsSgtNRdN8fOBFSGUzMQLfm1S0PnaZV3ic5OdUaVqRttdokGQWLsWDALM0wcg58mthB63huiJC60FOJon3yjxps65+a7Bs3vjx0xu6//JKFApJ1L4QElHd916zqA//qGm3tX/20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nNVgAiP6; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nNVgAiP6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763175254; x=1794711254;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=68kCnZXW4wUOPihlRkLhE3XY9iJfny2CtYwecW7RfTM=;
  b=nNVgAiP6j7SKTmlsKdc0o5fPgy++JFWQ30Oxo0GEBI77azXhYDFrVMDM
   XPLrrrl7rLHcFGvdq42IMJOndBOuQARpto/7QVtp8XDmWokxyl/4uIjLu
   ur6113cajHa7Hpr1WAWphwVq/P1bvEkyUtAOrNv3zavIfd5rLkv6MjshG
   OagBO0v+kt18FdSjhAbOgozF5XuEiLunGgyHDFajel35IJ1oTC2Ya+ZPA
   QF/qzs4OVMx8CG+aBCnC7kayfAqS4U4vxOyQAxryG9SLA0RT4uvSD9ALX
   xw2nkVh/fNiMfJcUEvSNd4dYqlPX5ILoK9wIRTObNg9WSi04i02S6iJWn
   g==;
X-CSE-ConnectionGUID: osHq8GlCQR6xPgFOeq2x8w==
X-CSE-MsgGUID: gid5FzqRSWOlMcqwr5O48Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="64273748"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="64273748"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 18:54:14 -0800
X-CSE-ConnectionGUID: AaQI+ZeXQ4aVo1R0G6ugxQ==
X-CSE-MsgGUID: 1V8edvDkRxKRdsGCCbv4SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="190116459"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 18:54:14 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 18:54:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 18:54:13 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 18:54:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KrGGad/C1Zu4vQkjJL0YeCu+1KXMWTZHdUgKx1EGSrmKwdf1kFCf5X1DPd86T1r78SgylDtnbmzjFkm7H/ttcFtp8WFk96F8nPta54wwKROFFmOidVn7cr5j3hlMVNQyNzS061T06NnhmRSKGWjCL7LY3FkloGKwTAxodlbTvqSmi0gVh3MgT0UTes9q21ZdekwmTTwapRubIMoouBYALJY8dWNOGawMyRK0NwMrh3XMc0PakbXkxWklXTyy3MAUWXO/wH9sL2gw5LPA5tf6GJOO7IVruxOrEbWBiQdSmxHN95egaXtFeAerYmoheVdoQks61bMyEeheei6PSsePvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKk85Hu3AgSz7zCOHnUnwUhk4P7NKiYxdRAwvKuV41w=;
 b=v4y7Z8H7/ySGQKh+OO9pGAb2E1vHxbe8t3cJgUEvXoiwwGhkPmNgDOKXOYJNMCFpMQa1NwUm23KwfCpeJUVOGIyWgMqeCyu4Yzsum7Tc+etjqYuYQRCUpGE8QkryPMev5NaUnxTejOJ8/ByON5mKL3JJXPkopA7m713NON4Qri0Viph2V2HY3TzbnbzYrRkuK+2b75vz4nAxuHrDEwZfU+l5zXdNTr6pH9eDrcJvSd+IOSzMnzhRFanC/U52Imm4NDgs81x8Z3OwWfNfrWa+HH05clio85c4ytIWf2RzoSZnNt20HH+tA8TiPFTzs8P2iwtjYOZUDqDQxuTD4dwFeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH7PR11MB5888.namprd11.prod.outlook.com (2603:10b6:510:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 15 Nov
 2025 02:54:10 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::46c9:7f71:993d:8aee%6]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 02:54:09 +0000
Date: Fri, 14 Nov 2025 18:54:05 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [NDCTL PATCH 1/5] cxl/test: Add test for extended linear cache
 support
Message-ID: <aRfrTZtRF54vyFfa@aschofie-mobl2.lan>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
 <20251031174003.3547740-2-dave.jiang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251031174003.3547740-2-dave.jiang@intel.com>
X-ClientProxiedBy: BYAPR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:a03:100::19) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH7PR11MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d34c7f7-2528-486a-a9d9-08de23f23fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2EFzMo1T2qNPV/i9oKekKyTVMiEBKO9SeuvbEEqh+OPGFjpBfwFsTctSbOlM?=
 =?us-ascii?Q?QHRwPoWWbsfCcitY4rPBu6dK2AMGFeDDSzkDnUXm+sIU4uNXA4toroIINZRA?=
 =?us-ascii?Q?G2EK+9SrC+OFFwDYnQ+AfBp6vX2/rxQDPd9uTOfvs3+hpQ/1rtZJx3A9ShgC?=
 =?us-ascii?Q?WbFE90ZQ0Qm3VIxhWL4ESZwATCKrzoRFJXu0UCgAD1VxXn8j27zeinpPA3pm?=
 =?us-ascii?Q?G9st5ffvAMh1GAbwZ11U7WUO3vFxLU+LlnVCCVHVne0edg7JyO5dv0G8BO7k?=
 =?us-ascii?Q?5HJ5m6euoGWjfoOrvbEm/cXPM/iv3AaLx5qSwEdyz9qw9uFw50hgvtbiNLsC?=
 =?us-ascii?Q?CEzjyLM3sDrMHWGnV5T3e54x/zhtPQhsdHWMcVn9bPOVUoBSnLZeOffBKMXC?=
 =?us-ascii?Q?xdSimajujNv5cJCLQXbY68Qb+nQhc+JP1sjXE7MQ8fCpPITIDA0iPQfiNVgr?=
 =?us-ascii?Q?OyvCJ5HjvmpbMtNG1YjPknDANt+5W8kozUTovJzV315KkW9nJKl6l3s2e4hV?=
 =?us-ascii?Q?szcGrJTp5xtf7ufGcDKT9QYE2sNldx3bSpTFu1J8aCPk9fSj52Lm1YIkwf2J?=
 =?us-ascii?Q?jO59qfz0h6CouSpFCzgvSiv3FEyMMPHy3F8ZE9a4y0JmxoANaQ/C+V6room9?=
 =?us-ascii?Q?cC2KGyQAx7dP35S+EYZLdsQQ6pjcmI87SwHm940IW7ovlpKafFojyYiHvrHi?=
 =?us-ascii?Q?tcDqn1SEpc8Gy/qblNZHy/bPctk6Wtb+Rl8dzKwhCgEP9yCtiMX5W3aAmvil?=
 =?us-ascii?Q?pqNGx31yv9eVnwuzcGCzjmKTxrjVM87loYjx+vEg0v+ot3QfkpSSc4rmhnB2?=
 =?us-ascii?Q?X9hDwlZHEkFY4f0rznEOSg8M3oMb2RGIppFlipYzJDagspp5LyYo5UUyyAJU?=
 =?us-ascii?Q?DQqxej1vjJr/v7poosKjuPiMDPBFYqx722xJiUDHhzcQWHBKtmssUcfgRarL?=
 =?us-ascii?Q?iF7G/rutBV67fCuhrNzEtuxn7dGQxLqWNlCzYlR7gfQRXIWXkUv2Uo+i7gnw?=
 =?us-ascii?Q?qVNQs+hAped1q0Ie8kctQVXHGoQuSgJsB9Cm0NIMTzzjZLawokEGZIfgcaoe?=
 =?us-ascii?Q?Ex1bkQFnzalcXklj69mg38OB8sLfH5Wci5GPx+Mdi+axknqFXXViNlyrJ0vN?=
 =?us-ascii?Q?UiPyS3HTZ6q4ZK+66bh72XdomBbPX0co/eV4+SZIjEj5igaGeMS/0WoogRgG?=
 =?us-ascii?Q?KLn1Vlo2pjl6226fELx5tn1axd1hwFmI15eBrDWy3+ZNzCuY2HsySIXoQtsM?=
 =?us-ascii?Q?yCigGQ4e9Q5FPkVwrbN/xxoGCNlQ7uR02lFhEbdjRsRHYxJb/uK+3CpRfWdq?=
 =?us-ascii?Q?DAmzBvfh32guG6Azi7m2naXTcpIc82V+kMo+HIU5uIwtrN7TKIUWJDDI5wjp?=
 =?us-ascii?Q?DrJSZ6mUHLHpeaI2Cp2F66GltGK+9HaumFBkIQVpHFsQOzfbxVLYb9AkA2uP?=
 =?us-ascii?Q?TbEFqE+VRFyM+4HBZ5YZkkp7Q01QnejC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?161IsHKJtfcGOiBNrVuRqbn31N1UPZzO5uEQhA8n4jM4w7mnHdw8Ivn59vpq?=
 =?us-ascii?Q?vIxJ1fGLi9k5ZpKzaOm7BH48rUg2AlkIvkOI98iAsApfztW8LBMq2FEXmgQP?=
 =?us-ascii?Q?qppiujd7sWiBwHbukYQLE1lNdrnucz19rfVsf0tpJjIxbaTExv5TTNZ8eqii?=
 =?us-ascii?Q?xXbylDNbYAGP3KunqoIB7I+4ltQZVCG4EQTo3W/NwT1o7/WtG/cJpku6WlKd?=
 =?us-ascii?Q?/K6TKSPO/kPvTbYdMN4TKDUrKXNXRpHenzt214hp7oiNwH2gQgpw/z0Rn8Dr?=
 =?us-ascii?Q?ZI/ZUBfj9BQCMMmIhjA11iRScLLy+mGIXR59cISYY00qsKgkGIyxApsN61xc?=
 =?us-ascii?Q?W2nTgHbT3Fm3UPh0X41RsIDzz9H1nGm6vl8g+tkmiAnxqZ/bkyzo0rievJ0F?=
 =?us-ascii?Q?4dwFiP1cgQmfc6/8BznrZade0/TmsXnd0QXvJAMxM1WwaNgIHjWBzfezGEAl?=
 =?us-ascii?Q?d5hwOeIV3OhBMCOHpB/6qf7fqPJFhynGFa/F2DeYLBcJWY7QkzBuMdq8Lr2d?=
 =?us-ascii?Q?o+zwwtvP1AIj0YFFFqd+XNlIzV8X4AIXGSQHSAoy77FVmQXKmYHNO4bUnNt7?=
 =?us-ascii?Q?gR8y5SoIblBWdsQJPOln2MA1MeUL5v0YguAay/RntTuvCzCfYUBTiScjvUuV?=
 =?us-ascii?Q?YpZNH9NbrKtI9FwwgePS+f6c12CScEt5oQ4HeMA0Zwmc2Q2ZkSo01CQ45Djb?=
 =?us-ascii?Q?VeF13LvxFnAebSCCsb1J2Arc0VKcDjoIynDLypaVKsBy2T/+8ib8G8pGPl92?=
 =?us-ascii?Q?jIVkXH5dm3OEVjVnyHNMBWeEuD9fTGEQiLWuOpGSKJkEYP7Jk57T7ST4f5+X?=
 =?us-ascii?Q?YTaNrhIUT142We8pAr3jmZHNF1U8ZrJzgAd+H+ymjiXooDwPg1Eyrbgg3/d0?=
 =?us-ascii?Q?i7TzYNEFIFuEOQ/5Q0lj2YK4ci5ZzEp2j/BVACBUz4gmtDuUh/LVAHhB0/t4?=
 =?us-ascii?Q?8OKLy9J2MIc4rCevyyTtgFsa10cv7yQSmYeCD/PvYxg7BTQXwbU3wginZdIJ?=
 =?us-ascii?Q?JgYrC1rRibGt4Q6THHx0p6dgiyMOiu7+0beenfVCtrO43CtRrrV/T57tl7/B?=
 =?us-ascii?Q?bgTN6xlgjvnmWum+jbtZkXj8broP7euFdT5e/gGFZDN+sf8u+YdrC5Gbd0OT?=
 =?us-ascii?Q?GFIApsPJgBqe3OKqmF6DymnX0h+coZ50jxhWeLUB4dyOcLbtk3a67kwF6bef?=
 =?us-ascii?Q?st3NJWSm6sajO/PK0C3G87ZakZtQI8LUMAy5udg6UmiOlosZpcTvhWEYCS6n?=
 =?us-ascii?Q?or3BYRdOMUYNlVlr02VAsnH6+lbfcQuxe7g0WsqFHmoLJDyEfmLOxh8dufCM?=
 =?us-ascii?Q?lXEZB5ChVEJMsf8xcdpU185HQQJy/54jF+SGcjsg5qQSq2BnVrtXqj9u+BaS?=
 =?us-ascii?Q?b5Q1XdQ7bk96wLaLYLq8cclf3e5r19/lyO8LXd7qwDOZC/MvkBru011AMzk1?=
 =?us-ascii?Q?4dfF/IoB02cO4cbQxr3XwW2TJ0pVHcEKrJdDURaOrjSM3BPU8ncY9wz+Qiqm?=
 =?us-ascii?Q?8V2T+3yasKMblkRDlWyKk7N71AIbOg76j8LCRLPOl0VGUxJ0U7e53zaAXcjg?=
 =?us-ascii?Q?zpJQCEf6nBrTPwBRj7q4wJpWB2OWW3f7q6syccf7XP2HKvyxgmJ4DVErWc58?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d34c7f7-2528-486a-a9d9-08de23f23fb9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 02:54:09.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdghPXerdUXWHrtXNpFlUb+9gpPv21aMK+kClNVM9fVD588RX7JMBAmmI/2jJhZdsHp3t7+4fypyeNQ4ZtGn+xNyBZSbuNYyhzSxAMNynkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5888
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 10:39:59AM -0700, Dave Jiang wrote:
> Add a unit test that verifies the extended linear cache setup paths
> in the kernel driver. cxl_test provides a mock'd version. The test
> verifies the sysfs attribute that indicates extended linear cache support
> is correctly reported. It also verifies the sizing and offset of the
> regions and decoders.
> 
> The expecation is that CFMWS covers the entire extended linear cache
> region. The first part is DRAM and second part is CXL memory in a 1:1
> setup. The start base for hardware decoders should be offsetted by the
> DRAM size.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-elc.sh  | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build |  2 ++
>  2 files changed, 91 insertions(+)
>  create mode 100755 test/cxl-elc.sh

snip
>

The call to this:

> +find_region()
> +{
> +	json="$($CXL list -b cxl_test -R)"
> +	region=$(echo "$json" | jq -r '.[] | select(has("extended_linear_cache_size") and .extended_linear_cache_size != null) | .region')
> +	[[ -n "$region" && "$region" != "null" ]] || do_skip "no test extended linear cache region found"
> +}
> +

is missing from here. Just found while testing w patches supporting the
parameter. So you can fix this and ignore my review comment about
looking up the parameter.

> +retrieve_info
> +compare_sizes
> +compare_bases


