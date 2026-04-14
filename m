Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113430FF31
	for <nvdimm@lists.linux.dev>; Tue, 14 Apr 2026 03:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776136381; cv=fail; b=YXW9f3e7fN6+HLcf/jHMW4DUqbRy6DAQAuJSfesELHNk0pvYit3ofJFvohAE91QM55y6lgyBc5jYDcth8SacXlYwgXToggLTKpk7lhX3mFp/yZ2lzbMn+Ce/SwHM2hd5K1woXDI0CKMRYDMOvPkeJG3anuziKF4GheIeOH5AJyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776136381; c=relaxed/simple;
	bh=Z1ZVkc+GF1Blb/1UJhHpEa3easgsl6S0eArTVxLPVNw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ELAmBRsf/jzJ8E9RSe8fA4LvJwTdaQr/Zjxlt4X+XvmvkFbosfEIHC8edXo0PC2I2gujp3jQcI89f1MQS4MRr1tDU3/0JnDABIWJkh2jwT4fEmKM+T5LRtSVgqO/whzY9r05NFE08hZGBm5HpAhCat+14LfOuQ6qn0BJiIo0wlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bt3+1t9r; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bt3+1t9r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776136378; x=1807672378;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z1ZVkc+GF1Blb/1UJhHpEa3easgsl6S0eArTVxLPVNw=;
  b=Bt3+1t9ryiHFGRJ7IueeUBp7ESsvevrH41oY4qDfRk7Q9bpvAqCeKGt1
   bNa7/dq007eFnZuK+wne+61Kq3QNiz4vS8CKogLk/zOORvQ8Nivj3oNNx
   a0voHKyGKin5oU6Ta8bEit4GsF5S+w8AO5QHHLaduNVXDqzhyQSifDGfr
   JQ9Pr+smSkTV2XfFOnoIDdVCglzM4R+X0yC46PDUuJe2oQbtQphHQ60JW
   fjtTmdGsai0Uu2c/5TOu9VpuOEk1XoPqY5e9KpHZrtYgzrTAp67jKs6U3
   8uKVsEzODuLGVZRMlignobumSO2NuMWa9ClbEk3eHVgQcitfaA4POycPg
   Q==;
X-CSE-ConnectionGUID: aQKVikQOQEKZGRgFUS5vog==
X-CSE-MsgGUID: yPHDKF2GSP2sr7V9VVQLTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="88464245"
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="88464245"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 20:12:57 -0700
X-CSE-ConnectionGUID: zUEmk2kMTRKMxhXhqJpEkA==
X-CSE-MsgGUID: Zhh4Os83RxmraEw/KXjLvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,178,1770624000"; 
   d="scan'208";a="234897650"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 20:12:57 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 20:12:56 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 13 Apr 2026 20:12:56 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.8) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 13 Apr 2026 20:12:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oVTDSBG7NsIPeAGhbJaoMrvUBntRaG9U/IcDVfEyhQs9Z2FXPomEKhmMiunX8xpb8iZ+gLFCc6M/3O4tmEGG0eGgeG7FswLm41116cd9jJv8YJUClvxDGOqCSIBYuc8m7iMKvzBzzYk73p/wlSaLdnjoCzixXMvoE6smzVVC+bZntJPowt1itwOJrAaVcthtvkRwtQduMEueVkNCrvLjPMbveMkei/O4+zKeOGXZLjowk4Ks/hoV2FXjiG7ICy+I5+pjvVTr1wQzPD44RHtflFMRdwHtinY6bvIgo02TUIoZ0x678iXoadec1ZTyeTTXQmRQ7py5BKYyDpSEiyngnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmMSfqUxukmqSi2nUhEJqPxr9C+3qM47MijBBMy0Z5I=;
 b=X2Vbr2eTHtQ7tSAdq+6TC+Kp8HnostZ9fW59OXbkw5WvJ01dVImQ4pNsnpSvkZwRVOTOzSEAR+9XOKnrHbIdAQQmAfTu0lsR9fapf30C1J+kxodfx1ly4P3JCy1kvggWx4Es4WO5c1jXdSv/dSsGakAYfOXg4dVGVSzVvbvOJvUIRY+Yzj6cfnQAdkyBpBfQUJsoJi/mVe12FvCAjZ0W/XIt+eF70RmLgcope86I3dB4RruKS+5zULH+iYeXIT9NoFoOD1kFG65cO047EZF9XK9kTwi1R8YMH/q4VK95xQAs535ODfV7O1IhjU/WlG+N+7yi1uEaVzTER90UBSbtoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DM4PR11MB5262.namprd11.prod.outlook.com (2603:10b6:5:389::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 03:12:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9818.017; Tue, 14 Apr 2026
 03:12:52 +0000
Date: Mon, 13 Apr 2026 20:12:49 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/3] test/cxl-destroy-region.sh: prevent false pass
 when no decoder found
Message-ID: <ad2wsZ3XJXaVyhd6@aschofie-mobl2.lan>
References: <c2eccb9b0e596820940bfc7ec839ff807f3ac613.1775265383.git.alison.schofield@intel.com>
 <d88b9334-181d-4fb6-a694-ef2618c44e1d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d88b9334-181d-4fb6-a694-ef2618c44e1d@intel.com>
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DM4PR11MB5262:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e0861e6-65e5-45ac-4006-08de99d3b74b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: yhEYElKrHJLkLYhZLmCLXG3lMr06Aej8gjZUSkWc7wJfUfW/bNV1IqC45pJUo7xR1EaEhXOzAwBNA3naBh+sAFQiOO7YlTxLtMGghd52zRr9oe+hnY0upjY6Pk7jqwy4LcEkk5kbxD3ZmNrwvGg8L2k2e7cJ9ocWXkiT3YTA89Z2WMJgiDwgaBIyC4rPWmlY6zW7o+oxjaOb7UXUCgyKHzJ7SZSPz45RWFwP0GEUw+I23jpyoCU2XrelcDQaS4MMircXPGghQ/+ekqxOU8NqTHwuOtjWseKGLwZi76Aic0x97j/32oqsGbtjHDagLOJ7ddj++okg4dP4mNbQJ8MNEOpg+9OhU4O+ck0idEMsSdWGDpXR4D6RbAZnKsf5q15pQu1x8EoATeCgsVphtQ7i34jwGbto5d/yOQ+v89vv0h7lZ/bdvjcxftVnIht5yBvfUjOQAxzK1XAQuad+mGsveA8bsbsBcXIFDl9s9mvLqBYxJvQA920Wp3BMYliHdEwWZmO4EaYTegmVouVHmL+r2T1vn7LXZSQUm9baVJD2dAWG3bwyhacr0ZjfaFgpe6gENi8kIgfSnwLx5T3Bf7HDKMBLtCEWtxLC4tJlbz5dFmzOJIMhVv7WiAgWhxOl97AZewhraRyE0p4o6CiDYfGzsSt8H7qYuZmwj2aoNPtAGwO4K3hq3DXC0AJAyaPRak3e+DKpVRd1EBii1E46mERZJqmU2FiGDmbUN8834zXzyqM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4+2V60v5pbBIN+BJLOUdL8OuQqyQ1B4pw8KHYSg0Kb/8jgpahr0DNTgosKbz?=
 =?us-ascii?Q?wwzGpYhIGER1VbhcdOOnXfw/Ms8khgb868hAyZYlS8MdUAV0xoOIcZMz6+qh?=
 =?us-ascii?Q?9VH8LxPnfPmb3U8xeP6hmmRmadWDPRam6G78a5rBpm0kj8sQYY3/yRkaDb8Q?=
 =?us-ascii?Q?aMc9x4xT+Gv6fORaP3wpsRzgM8bl9xICHsNRQDRe6RuaFpoqBNrnHL0PD+Ac?=
 =?us-ascii?Q?dNhrA24BfbsaN+GVrK2Pw5sz/W9htiAqScenxAePwXMmGsgRl24XW/IvpojK?=
 =?us-ascii?Q?D/t4h7efyxND4JOdjOU2IjsSQU9R/dYZztslWtf1ry3JvSRHHpVfmssYw5zz?=
 =?us-ascii?Q?yaiEIjoDT9aHOGEqh9UL4qL6qDVplzH7PJupbN4hm+f14jq0DGMVaXBniWit?=
 =?us-ascii?Q?K3ti8OrCsfeXzG7QIKIBbPDOXHhEkMRiFlYrukG3Gvm2254koR8eROW1SSik?=
 =?us-ascii?Q?nyrNrjlH2OOtPMQ0ilTysUrnaOKOzCt3CK6pwaJNUpMXGO7gu600Ue0vjhQc?=
 =?us-ascii?Q?Oozs0VpZYZQB6cswKUfPLQfsHIUcIFcliBvMWppG35SOOKevXGvrrZxYwdFP?=
 =?us-ascii?Q?VuxTmM/tppiHWHBEystJB/4ZJDN80u3TSOH8IWldmdePKHaLJEufAEabaoqm?=
 =?us-ascii?Q?Qg2oHNBhpdovjzW69JRu8L+u1wwZ42RHvqPI2yKR1D/kw5s5iQTj/+V4C0zC?=
 =?us-ascii?Q?Yp0OsEdAIKrySTNblG469oGiPHFtApIIKIGbHEflJh8lAaV3RgOmrGBvvTJw?=
 =?us-ascii?Q?Kiie7hy4Gf+9aZcu220za87hSiSava71c1qbeXDUpOns85PE0OsZIa/RBDe8?=
 =?us-ascii?Q?zFWJKgv9xIyD8L77LEonwg2IgsDhvODkqlZCnzTNhpLsenZiYwZvkXAO8N88?=
 =?us-ascii?Q?YaOR+gDKtkOkE8Y+HEG9D8x8nYSH7wVWNPgsLMJ3DkzDwWj6uK2UzZwMd8rH?=
 =?us-ascii?Q?mq+WBgC5bf3gbhJ5tYSUUixTIUBhqfgWRG6ZdGtGCne95B3ufSknxuvhgJr3?=
 =?us-ascii?Q?HqjYqksqpTPBaTmCgQ7hz7BLKb8psNapOIhNU/n5BEZkn1elbtLCebdvFF4m?=
 =?us-ascii?Q?QqaegK15Woe/3IVj/pqFmDb+lWCq2dHQOj4hgqrr2mKeWK3Lkn5VGmRcdRZ6?=
 =?us-ascii?Q?S3RvR+K9PQC0hTDmBBSZ5AnUdV9suGyvRy6DxXvIUK8I2lb5RerEqBGrlTc3?=
 =?us-ascii?Q?z0XwAcEAuQdtNfI4UkYrHDUkC2yIbUX/WGqmGvkreUVEcXqrCI/ra1Of07eh?=
 =?us-ascii?Q?u7MQhBFv6xeuuiyoyk2FHncfZ2Z3JOKAU8Zlq5/F4i97JQ9FdkbBcMwQSKdw?=
 =?us-ascii?Q?/sduQyt0ZSgr0CNHkgXIlCh82wlwS5NDWqVOSNf1Avu7jhTg+UVtCu1g6a34?=
 =?us-ascii?Q?Pp5Fkyny2D9LkrTA0d+l2EIYbSirKNFDgJibhyg9U9GIbn+Xed19M3yotPT2?=
 =?us-ascii?Q?ZzXJN7TKpD4ci+N/o5CztKv55sPMI6lrqXSFXvdvcPtx9hygxq/FrkZO7Y0W?=
 =?us-ascii?Q?oA5h+2L5JAqTRLaqIGPqqfUsaJWF4CN4FX/U14Pt7aGCk+cGQax4UeNiG39n?=
 =?us-ascii?Q?fKx/xfaymyuyVZFYeP2STI5nyoI3GhpLyBnEPezEwPhdufpfK2NbnE2MhjXC?=
 =?us-ascii?Q?VpXzmkSpMoXw80v+DtBv5kh4ySfxSIp3K7hjYMFPE9p0UBfRmMaLFFXrQJKI?=
 =?us-ascii?Q?A+IsCFh1fPltfrmEPkJV5psAc4GXowFxzpOOcf09WF5Wnt0+fM24vTV9Wvxk?=
 =?us-ascii?Q?47PHkpUFczF2YRAGyZDa2ZhWjnqoAs4=3D?=
X-Exchange-RoutingPolicyChecked: iuzx66WodClL6omQeB35513akMixaWdTLY4jCnLRI5geCiA/yfwpiVDEzXxL9bAUA/VnuiwlWZXmPUPl3Xx8TlGu3FwDoL9m6db2u9dWfNkMHUuHjzDq9XAtZzO02hnTf2NPVirLDPcV2NFB8amzegea8JkZBqJ6pm3A8s33/ps20ywX7QGJ54AUtoRfvAbr3ByvBqxSIXuB/H7JErECr1vRcRRlx/iUHdZu5bqRNv+vkYRnke0kxyJlwmBew1OdTpSCBghjzDj9O9du2zWW1EYPTgmUwDR51m2y0pWIzxBRTgsmL25ykf5cgtANsndqYK07Tkbymdz1S5G4PZH6Lw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0861e6-65e5-45ac-4006-08de99d3b74b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 03:12:52.6721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlG3ko89tQ/WAejWcIYQWznekTxu5ijvj92saPz8LreS3xDiVOqWQFjqNTQgkrFy1hfpHvIYhqzjeGm/4P4k3/5+rUJBMfVdiZxcCHgVmD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5262
X-OriginatorOrg: intel.com

On Mon, Apr 06, 2026 at 10:31:03AM -0700, Dave Jiang wrote:
> 
> 
> On 4/3/26 6:34 PM, Alison Schofield wrote:
> > The destroy-region test assumed a free decoder was available and
> > silently skipped execution when none could be found. When cxl_test
> > began creating an auto region on module load, it consumed the decoder
> > resource the test relied on, leading to false passes all the time.
> > This was recently noticed during review of test logs.
> > 
> > Clear all regions at test start to reclaim decoder resources. Fail
> > the test if no usable decoder is found and select the first match when
> > multiple decoders satisfy the query.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> For the series:
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks! Applied https://github.com/pmem/ndctl/tree/pending

