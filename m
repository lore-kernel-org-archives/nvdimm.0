Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E865F13AA38
	for <nvdimm@lists.linux.dev>; Fri,  9 Aug 2024 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723243129; cv=fail; b=pixvZGQL2Skq/MNzcF1sYuMlsGK5NNyD2J198ifZDYTG0q+/hWReC+I9GrsuZy9A2PxRYziV0fcuSqLAdSeX4zoY79hX2+6RqP0fv12AldswkeQDVl5ahFUUMlU7Lj+/gJgDJsQFIaHpbcfzce/InY8KUakeJhLebXKxravnSxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723243129; c=relaxed/simple;
	bh=HdWxhrTX1NVxavEIGc45skYxWquVoH/mVeafeYjPjk8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k+MvT9UCo1qJRmBYQse4EHzOXUIgZJZML7JASbeTYHEXHE3tjWuFl+hdG76pCsRvcxjuld8udN9lD5YGZcl1s51FKt8sW+QkDULke2nowV1bTFsk3GWcxRSR3NtokAcPZVDC+g/WkUBbZbvjjnSk6fBAXJKf3zy4FJFUC/FURAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LwSGYfL1; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LwSGYfL1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723243126; x=1754779126;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HdWxhrTX1NVxavEIGc45skYxWquVoH/mVeafeYjPjk8=;
  b=LwSGYfL1Zb5qAiOTBv4nZTiQ96wQ3JjQ86F7stA30scKmLeLsNVKTB9k
   tgeT+UPrEd4H1KQuMIDGVCSilw1bNYv+kXJE2QEu3SboPpNxj6wC135uW
   /HGu2WAd7Bo2ygMls50nxKnBm5EUVR263CydaDzDr7nJuRe6y/xZyoNAx
   eqspvuqMUB4CchQ5VqmiSr4jTfWOjNVsMvDgto8oXQA6kCtGPEXvcEQ7O
   0uQVkXw0ElaxHxpurQITVSoAzVhZ4lTHO/b92ehlU0WI9TCXeHwJbHuLg
   ZQ7YDq8Tb+fl7cFNwipoD93vjfoDxQrlUzY2NS2eAgE3xEX4CGAZd9xDJ
   Q==;
X-CSE-ConnectionGUID: KNS19cs8QB6zTvPgKOHylQ==
X-CSE-MsgGUID: 6whwjZCCRJW/OAOcx+jrXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11159"; a="21409230"
X-IronPort-AV: E=Sophos;i="6.09,277,1716274800"; 
   d="scan'208";a="21409230"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 15:38:45 -0700
X-CSE-ConnectionGUID: XcheEmyxSJOdw3egepbeLQ==
X-CSE-MsgGUID: oG8fQy+fQ2WLM8iFJtIgNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,277,1716274800"; 
   d="scan'208";a="88339104"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Aug 2024 15:38:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 15:38:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 9 Aug 2024 15:38:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 9 Aug 2024 15:38:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hdikjb0bhGkmfQ1P7089eQVjzO/bq2jTWfvJRprFhXxCU3Y/vDXt4VefEHPLnjbryaOgkd6NITNhk9Uv9Cu5BGjXlIOODIx3WFNzwrGl4Oxiip9nAnCbuT7Wnu+OiApXHq3Miw8grJfgcIK8SpB0ZCdtSRXornxlP/nNku4ZiiGiso3hl+Etu4VAlRScAPBH9TBZrQcWM+1+/wK/fEcoBXBhhuRvUbyqnWWi7VIxmbGD7PIoRRVl31iJ1et/XFjDOqehsYjkOrieSQ7iu4Qvv+ovgZ0m3Ct+IF4QWDeIxc2gXKFd4nLfcNwp4h7QE/ZZ+IefKKMa3YEOhqZ9PI1tGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcdY53i8M4pi9LTdm3rjuM6iY8asWJ7r4jrsmgMn71o=;
 b=Nw/5Dp4QXKgtN24bf9h84wjfAj+mNYLJksH19xwX63tTTNvD/cDqOp4F4TrSqdeN3+15KGkO7alpA2iNr9Y1Wp/B28DF3Q45LycYjsN/MlQOJoRZZwgp3hjvNN8TnIwwmGbb92aDoWjZ5DT/BvZXGqUhFJ3rITrzgEfO+x7DVEOk+a7dVaCtlXJTIOqIjUcJHLhjh/00wRDL6dhaO4Spsk7AIHjVMJbhWNjwmjCvMiu7Zzu8CgKjmZ+kCSgtYu+TE2yuzDBK6yrBck52BerwH5eN8zboJTahIo2vkEOg/7csX5oiVcYy8l+LKbyFtzvOo+I0HMtl//GxrqYt2imhGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA3PR11MB8001.namprd11.prod.outlook.com (2603:10b6:806:2f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29; Fri, 9 Aug
 2024 22:38:42 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Fri, 9 Aug 2024
 22:38:42 +0000
Date: Fri, 9 Aug 2024 15:38:39 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Message-ID: <66b69a6fc5710_257529458@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240719015836.1060677-1-lizhijian@fujitsu.com>
X-ClientProxiedBy: MW4PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:303:b9::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA3PR11MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: ea9d6b7b-1e63-46e8-a2f6-08dcb8c4054c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MtKQGYJUOh1jcF7v07yTHQC0qlv3jXHYngZ+kytgXOlr0dyumxdBJYP1cqZZ?=
 =?us-ascii?Q?WDafysO4lY7RbksUMt1My8LhH04e9rT5Tk4lYQTFUDpo2rD0cp6KmsjgM7ve?=
 =?us-ascii?Q?kc0PjIL7bDP24LbfBQrvzoUozFW++s3EXL3ucfsZY6TKrRujddPXQxxb7byG?=
 =?us-ascii?Q?+B7Hss6W5ymqPin1mzteiZAWQXLemKmjRD7FHHU0z0x05vfX/7puuV4VJz+Y?=
 =?us-ascii?Q?9QbmtrXvAfWH5GAvXFjEPW4D+YRMtlNj81E4TVU+uQyGPCaAuke4QrnJmqC1?=
 =?us-ascii?Q?jvdMBA/Dpim/IdYlBsg9qy3uxW/6TEUy8bQOx4fIIIC1zGFkgdBX23IehV8O?=
 =?us-ascii?Q?HshHxRxcS4+MGcLzrwgwx0yiE+ck6Z5MS/scWwv/LDoQmgO4YXGXc76KqYlQ?=
 =?us-ascii?Q?tOK6hUklEmr995fv2khD5FmIcV3Po3hRo9zeNPHPKSmaKWgeYHqgTnKe3VYy?=
 =?us-ascii?Q?RYByGNlC+QyEFh+7E2zBlJ1qf78EA3gxOdm4XaQfBWojW4IZcO+mbVO2jJTE?=
 =?us-ascii?Q?8fhI70KzNqRLP/R8Oxs+hbIeSdmJvMAYfzEvTvgMRl9YbtzqLomiiTiHpu+p?=
 =?us-ascii?Q?JKv0eH9GW6RNmLe5vvkmYZnafasP3hXSVUq938aFqJxTfjYQ47T+uILO+/ne?=
 =?us-ascii?Q?jB/cQj/0b+qhn0WqXZI0kK0rep3uaiLU+Z0tZICaAWMUkZ7cOW/kNBDwbNql?=
 =?us-ascii?Q?SAK7dVGWu4rWNfJFlgrd/Jx1L4Jv7qac1XyRHkYiDEVXL0wbV9FnM3Eh28z4?=
 =?us-ascii?Q?TyGmlBb24WgSRqem0DP92Pj++wRKi/CzeTpL/tyjDEnnfwvz0tsNEHlNFBXj?=
 =?us-ascii?Q?YCF8bdoS+iyistazZZLVXvbiY0ZygdEx14NXc/zUaVAg6gTfLaZeEJwgSh7m?=
 =?us-ascii?Q?jTRzu/VRgekIeTKgdvPdMZF9+bOW1hFiPwhC320xw8HaS5iLy7se2EBCZdQL?=
 =?us-ascii?Q?S4cyDJlRx5tsBATcJZhR9pdaYMqrOqtDiePV2FFJCWebJyktW93Gy3qVzHwi?=
 =?us-ascii?Q?DqlyVFQ1CoumtGGocIlhmfe1wjpi9814sgW1iGIUaFmXtJosYPSHUd+51Gqq?=
 =?us-ascii?Q?tPAyJaa3lEVpFvGj/6Cl9kVQcJom1cmxldTQSYfLCI0ln7GWSkQo3KQb0I/T?=
 =?us-ascii?Q?v72le8qh3k52RrtJ1tUDE7Pukn/3uFwKhnTe/GKxAXdfkSUOxOsdJbh3Shaq?=
 =?us-ascii?Q?1gQ7W/b6JXDXME75PGBiWapV5yjsVNG4+a3B9B33/xqrSIMrbOs3SS22n1v6?=
 =?us-ascii?Q?ZiG96j7DaiyB4Of9Sru/usAbJwLm6QxqdLpfSllp3USjSW7juxyHHTmXZ6bg?=
 =?us-ascii?Q?4b3VGvS2a6mNtuymjGQmIgwLLW0DdFJv76LBfGABHh8C/g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Aq0Zk8Y18AHBwtQzJmMRzrVxJbmhwMToi/OxfE+IYkgYagqieGaTdnU2iBL+?=
 =?us-ascii?Q?B8LCystAMQlMhoY+OFH+MErgs59HelYAFIQVwnSsiFZclUoh+q5hKqWdwgjk?=
 =?us-ascii?Q?dqrnNSD3W61SA1sKlM19QPJ4QEcag2taJ9bz0DBIOG+oqobcDlGdprSz9hgl?=
 =?us-ascii?Q?tWSLbIXpjvDSOrw3zLi5jsznxoD2MXKJZHOfPM8VKEgp34p22VfHeX7nDSvs?=
 =?us-ascii?Q?HPlVkiex5fKzP1xrQ+HOlLFtGWVaJbyLJWEy3xkxlBdCqsaTCey4BgJbqf4J?=
 =?us-ascii?Q?VXS8WDSAiagLfjlmO3a0lUpXodVaMXH3I/fqJKstHQDLDnqPXkcTZxZkAk1m?=
 =?us-ascii?Q?dA9zuApjw3alKvs0uPHL9xtTQbZJXa8teMf0RptxPMVSNHUS8xP+Tvg9vhZy?=
 =?us-ascii?Q?YbVS8x+hRqZkd+v6b65+F3m1Dy1984KO2f5XmfGdG04kJsylgmGTaHjGD38t?=
 =?us-ascii?Q?IhlHem1k3vj4dZerHf08nA5iYnY/FiXH5KdVAuwCZW5/Xd7fg00WKOBdI2ii?=
 =?us-ascii?Q?dHsBPqfgU1YMPpNcDLysiyY0+yincaB4JDFZH4a70daU/iOVBN/uqZPoOP4l?=
 =?us-ascii?Q?EeV7rLV7TTkWwDyPLm6BlJJ5C8S2ByRTX2WQ5ZVk/1bdBHklcoNwKi5oAlr1?=
 =?us-ascii?Q?/Clz100oxGcEx0V8pOWpHT8uv7b+4jiUFZElFBwf3UAk8F1WZ/HuYIOixT/K?=
 =?us-ascii?Q?d0TqSniiF4VR73zCiE5eg4WJwC1K8l/YPcZwqa8/bYucTU2Nadnpmkzs5F08?=
 =?us-ascii?Q?FPZ246kVKTaUH5zLvNeRUINyPa5ksCekJGBUInSeVYKA/EVTdHGy6aBDtzjP?=
 =?us-ascii?Q?IRSSLrFv8qT20PNl6GgcCSHBO9Y1bWZhXdTGPTbg/izNtEFi71tzvJ6q/hG+?=
 =?us-ascii?Q?B2KirbvhjFax9+KGJE3AiUATfiyvQ9NFlW8EnUlvZ/SmIOU03FFhUb8RV8Zz?=
 =?us-ascii?Q?O38ItZUCsDPbEjCHiPHExFsgM52E5e5GOktT8DGFCU4YQAZOKb3MqoP/NYfy?=
 =?us-ascii?Q?clFdWTN5qkvOC7c+mk7yfJFAkRChcZeP7M2Zt30F/3ZQwl+r3aKCDfdvu79H?=
 =?us-ascii?Q?TeqyPWE/vKnV94idZ0UHlXC/BVUUxeW3D04QDvE702BrRdAyEbQEQA5CN7k0?=
 =?us-ascii?Q?791ac6cWEdQKn+e25PHkYCvP8ApFhYNmt2l9mohxz3/ylbW/LNbBqdswx48J?=
 =?us-ascii?Q?iPxlNuU9gLdgqC2HsHUfBzVLKAPWaAcLqjLP0yUnftzghkjrSH0p61JMnc1d?=
 =?us-ascii?Q?A5cECEucRW7GgBU4uOo/Tjc3tpqnnlYAr6ikK4a2NVHygiRH0HbVfBirXXrb?=
 =?us-ascii?Q?8MdLn42UIIWlLL32gBLc+9XSUBIksob1eIOHMJBrl2YJ5x7E9/7PMXNBLtK6?=
 =?us-ascii?Q?ErzFKqcfRwMptOyrkajvjxxIiYKiHe7I8i4YBqaZst3PipDZywBjo5NeEKd3?=
 =?us-ascii?Q?4W0zSnMJ8sAPOd1bSU3JRJgrFvlAVKzpftGFjWPXJFMAVFCM4kVOxisWWjn5?=
 =?us-ascii?Q?cWHenNQJPVMLNY0aEN/XEjce/8jBGUFxMEm17wAiVaWtDJeX48pSZIDRqixE?=
 =?us-ascii?Q?DhPbpMps/MSCoqPox1aLbML1+ZpWPgImVR9SwqAzFNrU+MDE+Y7rkMlBSfOn?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9d6b7b-1e63-46e8-a2f6-08dcb8c4054c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 22:38:42.3857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3Il6F0x6UjKyjBV4YuTVsXblW93UZtGeFX2wiBOV1hfK0HP+CYw3rHWLQF7AM0gBCus95iTSCYI8NF39K3sXRjBYliI/geZnXu5eUB09C0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8001
X-OriginatorOrg: intel.com

I notice this patch is not upstream yet. Let's try to get it over the
goal line.

Li Zhijian wrote:
> The leakage would happend when create_namespace_pmem() meets an invalid
> label which gets failure in validating isetcookie.

I would rewrite this as:

"scan_labels() leaks memory when label scanning fails and it falls back
to just creating a default "seed" namespace for userspace to configure.
Root can force the kernel to leak memory."

...then a distribution developer knows the urgency to backport this fix.

> Try to resuse the devs that may have already been allocated with size
> (2 * sizeof(dev)) previously.

Rather than conditionally reallocating I think it would be better to
unconditionally allocate the minimum, something like:

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index d6d558f94d6b..1c38c93bee21 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1937,12 +1937,16 @@ static int cmp_dpa(const void *a, const void *b)
 static struct device **scan_labels(struct nd_region *nd_region)
 {
        int i, count = 0;
-       struct device *dev, **devs = NULL;
+       struct device *dev, **devs;
        struct nd_label_ent *label_ent, *e;
        struct nd_mapping *nd_mapping = &nd_region->mapping[0];
        struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
        resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
 
+       devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
+       if (!devs)
+               return NULL;
+
        /* "safe" because create_namespace_pmem() might list_move() label_ent */
        list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
                struct nd_namespace_label *nd_label = label_ent->label;
@@ -1961,12 +1965,14 @@ static struct device **scan_labels(struct nd_region *nd_region)
                        goto err;
                if (i < count)
                        continue;
-               __devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
-               if (!__devs)
-                       goto err;
-               memcpy(__devs, devs, sizeof(dev) * count);
-               kfree(devs);
-               devs = __devs;
+               if (count) {
+                       __devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
+                       if (!__devs)
+                               goto err;
+                       memcpy(__devs, devs, sizeof(dev) * count);
+                       kfree(devs);
+                       devs = __devs;
+               }
 
                dev = create_namespace_pmem(nd_region, nd_mapping, nd_label);
                if (IS_ERR(dev)) {
@@ -1994,10 +2000,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
                /* Publish a zero-sized namespace for userspace to configure. */
                nd_mapping_free_labels(nd_mapping);
 
-               devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
-               if (!devs)
-                       goto err;
-
                nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
                if (!nspm)
                        goto err;
@@ -2036,12 +2038,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
        return devs;
 
  err:
-       if (devs) {
-               for (i = 0; devs[i]; i++)
-                       namespace_pmem_release(devs[i]);
-               kfree(devs);
-       }
-       return NULL;
+        for (i = 0; devs[i]; i++)
+                namespace_pmem_release(devs[i]);
+        kfree(devs);
+        return NULL;
 }
 
 static struct device **create_namespaces(struct nd_region *nd_region)


> A kmemleak reports:
> unreferenced object 0xffff88800dda1980 (size 16):
>   comm "kworker/u10:5", pid 69, jiffies 4294671781
>   hex dump (first 16 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 0):
>     [<00000000c5dea560>] __kmalloc+0x32c/0x470
>     [<000000009ed43c83>] nd_region_register_namespaces+0x6fb/0x1120 [libnvdimm]
>     [<000000000e07a65c>] nd_region_probe+0xfe/0x210 [libnvdimm]
>     [<000000007b79ce5f>] nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
>     [<00000000a5f3da2e>] really_probe+0xc6/0x390
>     [<00000000129e2a69>] __driver_probe_device+0x78/0x150
>     [<000000002dfed28b>] driver_probe_device+0x1e/0x90
>     [<00000000e7048de2>] __device_attach_driver+0x85/0x110
>     [<0000000032dca295>] bus_for_each_drv+0x85/0xe0
>     [<00000000391c5a7d>] __device_attach+0xbe/0x1e0
>     [<0000000026dabec0>] bus_probe_device+0x94/0xb0
>     [<00000000c590d936>] device_add+0x656/0x870
>     [<000000003d69bfaa>] nd_async_device_register+0xe/0x50 [libnvdimm]
>     [<000000003f4c52a4>] async_run_entry_fn+0x2e/0x110
>     [<00000000e201f4b0>] process_one_work+0x1ee/0x600
>     [<000000006d90d5a9>] worker_thread+0x183/0x350

Thanks for including this.

With the above changes you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
